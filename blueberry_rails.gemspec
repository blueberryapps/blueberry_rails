# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blueberry_rails/version'

Gem::Specification.new do |spec|
  spec.name          = 'blueberry_rails'
  spec.version       = BlueberryRails::VERSION
  spec.authors       = ['BlueberryApps']
  spec.email         = ['jzajpt@blueberry.cz']
  spec.description   = %q{A Rails app template by BlueberryApps }
  spec.summary       = %q{A Rails app template by BlueberryApps}
  spec.homepage      = 'https://github.com/blueberryapps/blueberry_rails'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler', '~> 1.3'
  spec.add_dependency 'rails', '4.1.0.rc.2'

  spec.add_development_dependency 'rake'

  spec.required_ruby_version = '>= 1.9.2'

end

