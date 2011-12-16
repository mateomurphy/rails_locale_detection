require 'http_accept_language'
require 'rails/locale_detection'

begin
  ActionController::Base.include Rails::LocaleDetection 
rescue NameError
  
end