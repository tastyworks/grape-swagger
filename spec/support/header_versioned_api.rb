module HeaderVersionedApi
  class V1 < Grape::API
    version 'v1', using: :accept_version_header do
      namespace :item do
        get '/' do
          present({ version: 1 })
        end
      end

      add_swagger_documentation(add_version: true)
    end
  end

  class V2 < Grape::API
    version 'v2', using: :accept_version_header do
      namespace :item do
        get '/' do
          present({ version: 2 })
        end
      end

      add_swagger_documentation(add_version: true)
    end
  end

  class Base < Grape::API
    prefix :api
    mount V1
    mount V2
  end
end