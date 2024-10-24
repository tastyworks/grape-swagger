# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'tastyworks/grape_swagger/version'

Gem::Specification.new do |s|
  s.name        = 'tastyworks-grape_swagger'
  s.version     = Tastyworks::GrapeSwagger::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = %w(tastyworks)
  s.email       = ['developers@tastyworks.com']
  s.homepage    = 'https://github.com/tastyworks/grape-swagger'
  s.summary     = 'Add auto generated documentation to your Grape API that can be displayed with Swagger.'
  s.license     = 'MIT'

  s.metadata['rubygems_mfa_required'] = 'true'
  s.metadata['allowed_push_host'] = 'https://rubygems.pkg.github.com/tastyworks'
  s.metadata['github_repo'] = 'ssh://github.com/tastyworks/grape-swagger'

  s.required_ruby_version = '>= 2.5'
  s.add_runtime_dependency 'grape', '>= 1.3', '< 3.0'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']
end
