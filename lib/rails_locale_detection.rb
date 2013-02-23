require 'http_accept_language'
require 'active_support/core_ext'
require 'rails/locale_detection'

ActionController::Base.send :include, Rails::LocaleDetection if defined?(ActionController)
