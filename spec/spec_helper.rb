require 'logger'
require 'abstract_controller'
require 'action_controller'
require 'active_support/core_ext/integer/time'
require 'active_support/core_ext/numeric/time'
require 'active_support/testing/time_helpers'
require 'action_view'
require 'rspec/rails'
require 'rails_locale_detection'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

I18n.default_locale = :en
I18n.available_locales = [:en, :fr]

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.before(:each) { freeze_time }
  config.after(:each)  { travel_back }
end
