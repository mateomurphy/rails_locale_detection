require 'http_accept_language'
require 'rails/locale_detection'

ActionController::Base.send :include, Rails::LocaleDetection if defined?(ActionController)
