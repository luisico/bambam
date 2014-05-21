module ActiveModel
  module Validations

    class PathValidator < EachValidator
      def validate_each(record, attr_name, value)
        if value.blank?
          record.errors.add(attr_name, :blank)
          return
        end

        #verify the true path and remove any trailing slashes
        value.replace Pathname.new(value).cleanpath.to_s.strip

        if allowed_paths && !value.to_s.starts_with?(*allowed_paths)
          record.errors.add(attr_name, :inclusion)
          return
        end

        unless File.exist?(value)
          record.errors.add(attr_name, :exist)
          return
        end

        if File.file?(value)
          if !allow_empty? && File.zero?(value)
            record.errors.add(attr_name, :empty)
          end

        elsif File.directory?(value)
          if !allow_directory?
            record.errors.add(attr_name, :directory)
            return
          end

          if !allow_empty? && Dir[File.join value, '*'].empty?
            record.errors.add(attr_name, :empty)
          end

        else
          record.errors.add(attr_name, :ftype)
        end
      end

      private

      def allow_empty?
        options.include?(:allow_empty) ? options[:allow_empty] : false
      end

      def allow_directory?
        options.include?(:allow_directory) ? options[:allow_directory] : true
      end

      def allowed_paths
        options[:within] || options[:in]
      end
    end

    module HelperMethods
      def validates_path_of(*attr_names)
        validates_with PathValidator, _merge_attributes(attr_names)
      end
    end
  end
end