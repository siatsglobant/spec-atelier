module MetaLookupTable
  extend ActiveSupport::Concern

  included do
    searcheable_attributes = new.attribute_names - %w[id created_at updated_at]
    FIELDS = LOOKUP_TABLE.select {|item| searcheable_attributes.include? item['category'] }
    FIELDS.map {|a| a['category'] }.uniq.each {|field| new.send(:enum_methods, field) }

    after_find :define_methods
    after_update :define_methods
  end

  private

  def enum_methods(field)
    if send(field.to_sym).is_a? Array
      FIELDS.map {|a| a['category'] }.uniq.each do |field_|

        self.class.send :define_method, "#{field_}_values" do
          send(field_.to_sym).map(&:to_i).map do |item|
            FIELDS.select {|a| a['category'] == field_ && a['code'] == item }.first['value']
          end
        end

        FIELDS.select {|item| item['category'] == field_ }.each do |filtered_field|
          self.class.send :define_method, "#{filtered_field['value']}?" do
            send(field_.to_sym).map(&:to_i).include? filtered_field['code']
          end
        end
      end
    else
      self.class.send :enum, field.to_sym => enum_constructor(field)
    end
  end

  def enum_constructor(field)
    FIELDS.select {|a| a['category'] == field }.each_with_object({}) {|i, h| h[i['value']] = i['code'] }
  end

  def define_methods
    FIELDS.map {|a| a['category'] }.uniq.each do |field|
      self.class.send :define_method, "#{field}_spa" do
        FIELDS.select {|b| b['value'] == send(field.to_sym) }.first['translation_spa']
      end
    end
  end
end
