# frozen_string_literal: true
require 'rubyXL'
require 'rake'

namespace :db do
  namespace :load_excel do
    task tables: :environment do
      @excel = load_excel('tables.xlsx')
      load_data
    end

    private

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
      RubyXL::Parser.parse "lib/data/#{file_name}"
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
      sheet.each_with_index do |row, i|
        @keys = row.cells.map {|c| c&.value&.delete(' ')&.to_sym if c }.compact if i.zero?
        class_name.create!(params(row)) unless i.zero?
      end
    end

    def class_name(name)
      name.camelize.constantize
    end

    def params(row)
      values = row.cells.map(&:value).map {|item| item.try(:include?, '[') ? array_param(item) : item }
      @keys.zip(values).to_h.except(:id)
    end

    def array_param(param)
      param.gsub('[', '').gsub(']', '').split(',').map(&:to_i)
    end
  end
end
