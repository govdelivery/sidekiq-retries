# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sidekiq/retries/version'

Gem::Specification.new do |spec|
  spec.name          = "sidekiq-retries"
  spec.version       = Sidekiq::Retries::VERSION
  spec.authors       = ["Benjamin Ortega"]
  spec.email         = ["ben.ortega@gmail.com"]
  spec.description   = %q{Enhanced retry logic for Sidekiq workers}
  spec.summary       = %q{Enhanced retry logic for Sidekiq workers}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sidekiq', '>= 5.0.0'
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'activesupport', '~> 4'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rspec-sidekiq'
end
