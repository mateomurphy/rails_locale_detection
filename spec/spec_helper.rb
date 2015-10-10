require 'abstract_controller'
require 'action_controller'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/numeric/time'
require 'action_view'
require 'rspec/rails'
require 'timecop'
require 'rails_locale_detection'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

I18n.default_locale = :en
I18n.available_locales = [:en, :fr]
Timecop.freeze
