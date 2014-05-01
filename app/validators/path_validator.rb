module ActiveModel
  module Validations

    class PathValidator < EachValidator
      def validate_each(record, attr_name, value)
        unless File.exist?(value)
          record.errors.add(attr_name, :exist)
        end
      end
    end

    module HelperMethods
      def validates_path_of(*attr_names)
        validates_with PathValidator, _merge_attributes(attr_names)
      end
    end
  end
end
