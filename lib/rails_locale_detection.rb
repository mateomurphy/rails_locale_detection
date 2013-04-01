require 'rails'
require 'active_support/core_ext'
require 'i18n'
require 'http_accept_language'
require "rails_locale_detection/filter"

module RailsLocaleDetection
  require 'rails_locale_detection/railtie' if defined?(Rails)

  mattr_accessor :locale_expiry
  @@locale_expiry = 3.months

  mattr_accessor :set_default_url_option
  @@set_default_url_option = :always

  mattr_accessor :detection_order
  @@detection_order = [:user, :param, :cookie, :request]

  def self.config
    yield self
  end
end

module Rails
  LocaleDetection = ::RailsLocaleDetection
end