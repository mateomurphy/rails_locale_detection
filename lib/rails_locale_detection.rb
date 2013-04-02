require 'rails'
require 'i18n'
require 'http_accept_language'
require 'rails_locale_detection/detection_methods'
require 'rails_locale_detection/locale_accessors'
require 'rails_locale_detection/locale_detector'
require 'rails_locale_detection/controller_methods'

module RailsLocaleDetection
  require 'rails_locale_detection/railtie' if defined?(Rails)

  mattr_accessor :locale_expiry
  @@locale_expiry = 3.months

  mattr_accessor :set_default_url_option
  @@set_default_url_option = :always

  mattr_accessor :detection_order
  @@detection_order = [:param, :user, :cookie, :request]

  mattr_accessor :automatically_detect
  @@automatically_detect = true

  mattr_accessor :locale_key
  @@locale_key = :locale

  def self.config
    yield self
  end
end

module Rails
  LocaleDetection = ::RailsLocaleDetection
end