module Api
  class Item < Grape::API
    version 'v1', using: :path

    namespace :item do
      get '/'
    end

    namespace :otherItem do
      get '/'
    end
  end

  class Base < Grape::API
    prefix :api
    mount Api::Item
    add_swagger_documentation add_version: true
  end
end