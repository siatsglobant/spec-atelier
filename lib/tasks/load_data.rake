# frozen_string_literal: true

require 'rubyXL'
require 'rake'
require 'google_drive'

namespace :db do
  namespace :load_excel do
    task tables: :environment do
      download_from_google_drive
      load_excel('bd.xlsx')
      load_data
    end

    private

    def download_from_google_drive
      session = GoogleDrive::Session.from_config('config/google_drive_config.json')
      file = session.file_by_title('bd.xlsx')
      file.download_to_file("lib/data/bd.xlsx")
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
      sheet.each_with_index do |row, i|
        @keys = row.cells.map {|c| c&.value&.delete(' ')&.to_sym if c }.compact if i.zero?
        class_name.create!(params(row)) unless i.zero? || row.cells.first.nil? || row.cells.first&.value.nil?
      rescue StandardError => e
        puts e
      end
      puts ' done'
    end

    def class_name(name)
      name.camelize.constantize
    end

    def params(row)
      values = row.cells.map {|a| a&.value }.map {|item| item.try(:include?, '[') ? array_param(item) : item }
      @keys.zip(values).to_h.except(:id, :pdf, :dwg, :images)
    end

    def array_param(param)
      param.gsub('[', '').gsub(']', '').split(',').map(&:to_i)
    end
  end
end
