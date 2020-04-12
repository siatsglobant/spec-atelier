# frozen_string_literal: true

require 'rubyXL'
require 'rake'
require 'google_drive'
require 'google/cloud/storage'
require 'uri'

namespace :db do
  namespace :load do
    task :before_hook do
      google_drive_session
      download_excel_from_google_drive
    end

    task tables: :environment do
      load_data
    end

    task images: :environment do
      process_images
    end

    tasks = Rake.application.tasks.select {|a| a if ['db:load:tables', 'db:load:images'].include?(a.to_s) }
    tasks.each {|task| task.enhance [:before_hook] }

    private

    def process_images
      Attached::File.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!('files')
      products = @excel.worksheets.select {|a| a if a.sheet_name == 'product' }.first
      products.each_with_index do |row, i|
        @keys = row.cells.map {|c| c&.value&.delete(' ')&.to_sym if c }.compact if i.zero?
        next if i.zero? || row.cells.first.nil? || row.cells.first&.value.nil?

        product_params = params(row)
        next if product_params[:images].blank?

        images = product_params[:images].split(',').map {|a| a.gsub(/\s+/, '') }
        images.each_with_index {|image, index| attach_image(image, product_params[:id], index) }
      rescue StandardError => e
        puts e
      end
    end

    def attach_image(image, product_id, index)
      puts '*' * 100
      puts image
      file = @google_drive_session.file_by_title(image)
      unless file.nil? || storage_bucket.file(image).present?
        product = Product.find(product_id)
        file.download_to_file("lib/data/temp/#{file.name}")
        image = storage_bucket.upload_file("lib/data/temp/#{file.name}", "products/#{product.brand.name}-#{file.name}")
        sh "rm lib/data/temp/#{file.name}"
        attach_image_to_product(image, product, index)
      end
    end

    def attach_image_to_product(file, product, index)
      image = Attached::Image.create!(name: File.basename(file.name), order: index, owner: product, url: file.public_url )
      product.images << image
    end

    def storage_bucket
      @storage_bucket ||= begin
        File.open('config/google_storage.json', 'w') {|f| f.write(ENV['GOOGLE_APPLICATION_CREDENTIALS']) }
        storage = Google::Cloud::Storage.new(
          project_id:  "spec-atelier",
          credentials: 'config/google_storage.json'
        )
        sh 'rm config/google_storage.json'
        storage.bucket(ENV['GOOGLE_BUCKET_IMAGES'])
      end
    end

    def google_drive_session
      @google_drive_session ||= begin
        File.open('config/google_drive.json', 'w') {|f| f.write(ENV['GOOGLE_DRIVE_CONFIG']) }
        drive_session = GoogleDrive::Session.from_config('config/google_drive.json')
        sh 'rm config/google_drive.json'
        drive_session
      end
    end

    def download_excel_from_google_drive
      file = @google_drive_session.file_by_title('bd.xlsx')
      file.download_to_file("lib/data/bd.xlsx")
      load_excel('bd.xlsx')
    end

    def reset(table_name)
      database_connection
      class_name(table_name).delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!(table_name.pluralize)
    end

    def database_connection
      Section.connection
      Item.connection
      Subitem.connection
      Brand.connection
    end

    def load_excel(file_name)
      @excel = RubyXL::Parser.parse "lib/data/#{file_name}"
    end

    def load_data
      @excel.worksheets.each do |sheet|
        sheet_name = sheet.sheet_name
        reset(sheet_name)
        iterate_sheet_rows(sheet_name, sheet)
      end
    end

    def iterate_sheet_rows(sheet_name, sheet)
      class_name = class_name(sheet_name)
      print "Seeding #{sheet_name.downcase.pluralize}..."
      sheet.each_with_index do |row, index|
        @keys = row.cells.map {|c| c&.value&.delete(' ')&.to_sym if c }.compact if index.zero?
        class_name.create!(params(row).except(:id, :pdf, :dwg, :images)) unless empty_row?(index, row)
      rescue StandardError => e
        puts e
      end
      puts ' done'
    end

    def empty_row?(index, row)
      index.zero? || row.cells.first.nil? || row.cells.first&.value.nil?
    end

    def class_name(name)
      name.camelize.constantize
    end

    def params(row)
      values = row.cells.map {|a| a&.value }.map {|item| item.try(:include?, '[') ? array_param(item) : item }
      @keys.zip(values).to_h
    end

    def array_param(param)
      param.gsub('[', '').gsub(']', '').split(',').map(&:to_i)
    end
  end
end
