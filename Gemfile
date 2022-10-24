# frozen_string_literal: true

source 'http://rubygems.org'

ruby RUBY_VERSION

gemspec

gem 'grape', case version = ENV.fetch('GRAPE_VERSION', '~> 1.6')
             when 'HEAD'
               { git: 'https://github.com/ruby-grape/grape' }
             else
               version
             end

gem ENV.fetch('MODEL_PARSER', nil) if ENV.key?('MODEL_PARSER')

group :development, :test do
  gem 'bundler'
  gem 'grape-entity'
  gem 'pry', platforms: [:mri]
  gem 'pry-byebug', platforms: [:mri]

  gem 'rack', '~> 2.2'
  gem 'rack-cors'
  gem 'rack-test'
  gem 'rake'
  gem 'rdoc'
  gem 'rspec', '~> 3.9'
  gem 'rubocop', '~> 1.0', require: false
  gem 'webrick'
end

group :test do
  gem 'coveralls_reborn', require: false

  gem 'ruby-grape-danger', '~> 0.2.0', require: false
  gem 'simplecov', require: false
end

package_cloud_token = '40a5c0a37bf51a44a56c18adcf1d28e6ddea73dcfc257d79'
package_cloud_url = "https://#{package_cloud_token}:@packagecloud.io/tastyworks/gems"
group :test, :development do
  unless ENV['MODEL_PARSER'] == 'grape-swagger-entity'
    gem 'grape-swagger-entity', git: 'https://github.com/ruby-grape/grape-swagger-entity'
  end

  source package_cloud_url do
    gem 'tastyworks-development_dependencies', '~> 2.24', '>= 2.24.1'
  end
end
