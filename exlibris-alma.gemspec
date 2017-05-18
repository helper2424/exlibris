# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exlibris/version'

Gem::Specification.new do |spec|
  spec.name = 'exlibris-alma'
  spec.version = Exlibris::VERSION
  spec.authors = ['Eugene Mironov', 'Michael Harrison']
  spec.email = ['michael@ereserve.com.au']

  spec.summary = %q{}
  spec.description = %q{}
  spec.homepage = "TODO: Put your gem's website or public repo URL here."

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'oj', '~> 2.15.0'
  spec.add_dependency 'rest-client', '~> 2.0.0'
  spec.add_dependency 'marcus', '~> 0.5.22'
  spec.add_dependency 'library_stdnums', '~> 1.4.2'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'vcr', '~> 3.0.0'
  spec.add_development_dependency 'webmock', '~> 2.0.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
end
