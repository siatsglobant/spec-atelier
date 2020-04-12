module Attached
  class Image < Attached::File

    before_validation(on: :create) do
      owner = self.owner.class.find(self.owner.id)
      self.order = owner.images.present? ? owner.images.map(&:order).max + 1 : 0
    end

    def all_formats
      %i[thumb small medium].each_with_object({}) {|key, h| h[key] = "#{url.gsub(name, '')}resized-#{key}-#{name}" }
    end
  end
end
