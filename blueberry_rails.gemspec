# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blueberry_rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'blueberry_rails'
  spec.version       = BlueberryRails::VERSION
  spec.authors       = ['Blueberryapps']
  spec.email         = ['jzajpt@blueberry.cz']
  spec.description   = %q{A Rails app template by BlueberryApps }
  spec.summary       = %q{A Rails app template by BlueberryApps}
  spec.homepage      = 'https://github.com/blueberryapps/blueberry_rails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest', '~> 4.7'
  spec.add_dependency 'rails', '4.0.0'
end

