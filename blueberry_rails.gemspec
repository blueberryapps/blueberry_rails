# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blueberry_rails/version'

Gem::Specification.new do |gem|
  gem.name          = 'blueberry_rails'
  gem.version       = BlueberryRails::VERSION
  gem.authors       = ['BlueberryApps']
  gem.email         = ['jzajpt@blueberry.cz']
  gem.description   = %q{A Rails app template by BlueberryApps}
  gem.summary       = %q{A Rails app template by BlueberryApps}
  gem.homepage      = 'https://github.com/blueberryapps/blueberry_rails'
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'bundler', '~> 1.17'
  gem.add_dependency 'rails', BlueberryRails::RAILS_VERSION

  gem.add_development_dependency 'rake'

  gem.required_ruby_version = '>= 2.5.1'

end
