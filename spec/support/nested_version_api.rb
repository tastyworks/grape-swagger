module NestedVersionApi
  class V1 < Grape::API
    version 'v1', using: :path do
      resource :item do
        get '/' do
          present({ version: 1 })
        end
      end

      add_swagger_documentation(add_version: true)
    end
  end

  class V2 < Grape::API
    version 'v2', using: :path do
      resource :item do
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