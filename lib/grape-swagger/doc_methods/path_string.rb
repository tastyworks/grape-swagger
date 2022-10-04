# frozen_string_literal: true

module GrapeSwagger
  module DocMethods
    class PathString
      IGNORED_VERSIONS = ['1.0.0', 'v1'].freeze

      class << self
        def build(route, options = {})
          path = route.path.dup
          # always removing format
          path.sub!(/\(\.\w+?\)$/, '')
          path.sub!('(.:format)', '')

          # ... format path params
          path.gsub!(/:(\w+)/, '{\1}')

          # set item from path, this could be used for the definitions object
          path_name = path.gsub(%r{/{(.+?)}}, '').split('/').last
          item = path_name.present? ? path_name.singularize.underscore.camelize : 'Item'

          path = build_versioned_path(path, route, options)

          path = "#{OptionalObject.build(:base_path, options)}#{path}" if options[:add_base_path]

          [item, path.start_with?('/') ? path : "/#{path}"]
        end

        private

        def build_versioned_path(path, route, options)
          return path unless options[:add_version]

          version = GrapeSwagger::DocMethods::Version.get_single(route)

          if version.blank? || IGNORED_VERSIONS.include?(version)
            path.sub('/{version}', '')
          elsif options[:path_versioning]
            path.sub('{version}', version.to_s)
          else
            "#{path} (#{version})"
          end
        end
      end
    end
  end
end
