# frozen_string_literal: true

require 'rake'
require 'rake/tasklib'
require 'rack/test'
require_relative 'util'

module GrapeSwagger
  module Rake
    class OapiTasks < ::Rake::TaskLib
      include Rack::Test::Methods

      attr_reader :oapi

      def initialize(api_class)
        super()

        if api_class.is_a? String
          @api_class_name = api_class
        else
          @api_class = api_class
        end

        define_tasks
      end

      private

      def api_class
        @api_class ||= @api_class_name.constantize
      end

      def define_tasks
        namespace :oapi do
          fetch
          validate
        end
      end

      # tasks
      #
      # get swagger/OpenAPI documentation
      def fetch
        desc 'generates OpenApi documentation …
          params (usage: key=value):
          store    – save as JSON file, default: false            (optional)
          resource - if given only for that it would be generated (optional)'
        task fetch: :environment do
          # :nocov:
          Util.swagger_doc_url_data_for(api_class).each do |url_data|
            make_request(url_data[:path], url_data[:api_version])

            save_to_file? ? File.write(url_data[:file_path], @oapi) : $stdout.print(@oapi)
          end

          # :nocov:
        end
      end

      # validates swagger/OpenAPI documentation
      def validate
        desc 'validates the generated OpenApi file …
          params (usage: key=value):
          resource - if given only for that it would be generated (optional)'
        task validate: :environment do
          # :nocov:
          ENV['store'] = 'true'
          ::Rake::Task['oapi:fetch'].invoke
          exit if error?

          Util.swagger_doc_url_data_for(api_class).each do |url_data|
            output = system "swagger-cli validate #{url_data[:file_path]}"
            $stdout.puts 'install swagger-cli with `npm install swagger-cli -g`' if output.nil?

            FileUtils.rm(url_data[:file_path])
          end
          # :nocov:
        end
      end

      # helper methods
      #
      # rubocop:disable Style/StringConcatenation
      def make_request(url, version = nil)
        header('Accept-Version', version) if version.present?
        get url

        @oapi = JSON.pretty_generate(
          JSON.parse(last_response.body, symolize_names: true)
        ) + "\n"
      end
      # rubocop:enable Style/StringConcatenation

      def save_to_file?
        ENV.fetch('store', nil).present? && !error?
      end

      def error?
        JSON.parse(@oapi).keys.first == 'error'
      end

      def app
        api_class.new
      end
    end
  end
end
