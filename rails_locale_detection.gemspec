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

  gem.required_ruby_version = '>= 3.1'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.require_paths = ['lib']

  gem.add_dependency('http_accept_language', '~> 2.1')
  gem.add_dependency('rails', '>= 6.1')

  gem.add_development_dependency('appraisal', '~> 2.5')
  gem.add_development_dependency('gem-release', '~> 2.2')
  gem.add_development_dependency('rake', '~> 13.0')
  gem.add_development_dependency('rspec-rails', '~> 6.1')
end
