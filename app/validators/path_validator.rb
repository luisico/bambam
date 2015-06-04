module ActiveModel
  module Validations

    class PathValidator < EachValidator
      def validate_each(record, attr_name, value)
        # Check value is not blank unless record responds to full_path
        if value.blank? && full_path(record, value).blank?
          record.errors.add(attr_name, :blank)
          return
        end

        # Verify the true path and remove any trailing slashes
        value.replace(Pathname.new(value).cleanpath.to_s.strip) if value.present?

        if allowed_paths && !value.to_s.starts_with?(*allowed_paths)
          record.errors.add(attr_name, :inclusion)
          return
        end

        unless File.exist?(full_path(record, value))
          record.errors.add(attr_name, :exist)
          return
        end

        if File.symlink?(full_path(record, value))
          record.errors.add(attr_name, :symlink)
          return
        end

        if File.file?(full_path(record, value))
          if !allow_file?
            record.errors.add(attr_name, :file)
            return
          elsif !allow_empty? && File.zero?(full_path(record, value))
            record.errors.add(attr_name, :empty)
          end

        elsif File.directory?(full_path(record, value))
          if !allow_directory?
            record.errors.add(attr_name, :directory)
            return
          end

          if !allow_empty? && Dir[File.join full_path(record, value), '*'].empty?
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

      def allow_file?
        options.include?(:allow_file) ? options[:allow_file] : true
      end

      def allowed_paths
        options[:within] || options[:in]
      end

      def full_path(record, value)
        begin
          record.full_path
        rescue NoMethodError
          value
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
