require 'abstract_controller'
require 'action_controller'
require 'active_support'
require 'rspec/rails'
require 'timecop'
require 'rails_locale_detection'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

I18n.default_locale = :en
I18n.available_locales = [:en, :fr]
Timecop.freeze

