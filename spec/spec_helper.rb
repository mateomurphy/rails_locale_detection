$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'action_dispatch/middleware/cookies'
require 'timecop'

require 'rails'
require 'active_support/core_ext'
require 'i18n'
require 'http_accept_language'

require 'rails_locale_detection'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|

end