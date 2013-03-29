require 'rspec'
require 'action_dispatch/middleware/cookies'
require 'timecop'
require 'rails'
require 'active_support/core_ext'
require 'i18n'
require 'http_accept_language'
require 'rails_locale_detection'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}