# frozen_string_literal: true

require File.expand_path(Pathname.new('lib/trace_method/version'), __dir__)

Gem::Specification.new do |spec|
  spec.name          = 'trace_method'
  spec.version       = TraceMethod::VERSION
  spec.authors       = ['Michael Herold']
  spec.email         = ['opensource@michaeljherold.com']

  spec.summary       = 'Trace calls to a method with flexible backends'
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/michaelherold/trace_method'
  spec.license       = 'MIT'

  if spec.respond_to?(:metadata)
    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/michaelherold/trace_method'
    spec.metadata['changelog_uri'] = 'https://github.com/michaelherold/trace_method/tree/CHANGELOG.md'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = %w[CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md]
  spec.files += %w[trace_method.gemspec]
  spec.files += Dir['lib/**/*.rb']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler'
end
