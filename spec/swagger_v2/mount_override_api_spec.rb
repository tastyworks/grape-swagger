# frozen_string_literal: true

require 'spec_helper'

describe 'mount override api' do
  def app
    old_api = Class.new(Grape::API) do
      desc 'old endpoint', success: { code: 200, message: 'old message' }
      params do
        optional :param, type: Integer, desc: 'old param'
      end
      get do
        'old'
      end
    end

    new_api = Class.new(Grape::API) do
      desc 'new endpoint', success: { code: 200, message: 'new message' }
      params do
        optional :param, type: String, desc: 'new param'
      end
      get do
        'new'
      end
    end

    Class.new(Grape::API) do
      mount new_api
      mount old_api

      add_swagger_documentation format: :json
    end
  end

  it_behaves_like 'overridden endpoint'
end
