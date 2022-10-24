module GrapeSwagger
  module Rake
    class Util
      class << self
        def swagger_doc_url_data_for(api_class)
          api_class.routes
                   .select { |route| route.path.include?('doc') }
                   .reject { |route| route.path.include?(':name') }
                   .map { |route| swagger_doc_version_data(route, api_class) }
        end

        def swagger_doc_version_data(oapi_route, api_class)
          version = oapi_route.version.to_s
          path = sanitize_doc_url(oapi_route.path)

          {
            path: format_doc_url_with_version(path, version),
            api_version: version,
            file_path: file_path(version)
          }
        end

        def sanitize_doc_url(url)
          url.sub(/\(\.\w+\)$/, '').sub(/\(\.:\w+\)$/, '')
        end

        def format_doc_url_with_version(url, api_version)
          url_with_version = url.sub(':version', api_version.to_s)
          [url_with_version, ENV.fetch('resource', nil)].join('/').chomp('/')
        end

        def file_path(api_version)
          version_suffix = api_version.blank? ? '' : "_#{api_version}"
          store = ENV.fetch('store', nil)
          
          name = if store == 'true' || store.blank?
                   "swagger_doc#{version_suffix}.json"
                 else
                   store.sub('.json', "#{version_suffix}.json")
                 end

          File.join(Dir.getwd, name)
        end
      end
    end
  end
end
