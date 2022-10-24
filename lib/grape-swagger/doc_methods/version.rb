# frozen_string_literal: true

module GrapeSwagger
  module DocMethods
    class Version
      class << self
        def get(route)
          version = route.version || route.options[:version]
          # for grape version 0.16.2, the version can be a string like '[:v1, :v2]'
          # for grape version bigger than 0.16.2, the version can be a array like [:v1, :v2]
          if version.is_a?(String) && version.start_with?('[') && version.end_with?(']')
            instance_eval(version)
          else
            version
          end
        end

        def get_single(route)
          version = get(route)
          version = version.first while version.is_a?(Array)

          version
        end
      end
    end
  end
end
