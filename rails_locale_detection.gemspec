# encoding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails_locale_detection/version'

Gem::Specification.new do |gem|
  gem.name          = "rails_locale_detection"
  gem.version       = RailsLocaleDetection::VERSION
  gem.authors       = ["Mateo Murphy"]
  gem.email         = ["mateo.murphy@gmail.com"]
  gem.description   = "Sets the current locale of a request using a combination of params, cookies, and http headers"
  gem.summary       = "Locale setting for rails projects"
  gem.homepage      = "https://github.com/mateomurphy/rails_locale_detection"
  gem.license       = 'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency('http_accept_language', '~> 2.0.5')
  gem.add_dependency('rails', '>= 3.2.0')

  gem.add_development_dependency('appraisal', '~> 2.2.0')
  gem.add_development_dependency('bundler', '~> 1.16.2')
  gem.add_development_dependency('i18n', '~> 0.7.0')
  gem.add_development_dependency('gem-release', '~> 0.5.3')
  gem.add_development_dependency('rake', '~> 11.2.2')
  gem.add_development_dependency('rspec-rails', '~> 3.0')
  gem.add_development_dependency('timecop', '~> 0.6.1')
  gem.add_development_dependency('test-unit', '~> 3.0')
end
