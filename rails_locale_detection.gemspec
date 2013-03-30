# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/locale_detection/version'

Gem::Specification.new do |gem|
  gem.name          = "rails_locale_detection"
  gem.version       = RailsLocaleDetection::VERSION
  gem.authors       = ["Mateo Murphy"]
  gem.email         = ["mateo.murphy@gmail.com"]
  gem.description   = "Sets the current locale of a request using a combination of params, cookies, and http headers"
  gem.summary       = "Locale setting for rails project"
  gem.homepage      = "https://github.com/mateomurphy/rails_locale_detection"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']
  
  gem.add_dependency('rails', '~> 3.2.13')
  gem.add_dependency('http_accept_language', '~> 1.0.2')
  
  gem.add_development_dependency('i18n', '~> 0.6.1')
  gem.add_development_dependency('timecop', '~> 0.6.1')
  gem.add_development_dependency('actionpack', '~> 3.2.13')
  gem.add_development_dependency('rspec', '~> 2.12.0')
  gem.add_development_dependency('bundler', '~> 1.3.4')
  gem.add_development_dependency('gem-release', '~> 0.5.3')  
  gem.add_development_dependency('rake', '~> 10.0.4')  
end
