# rails_locale_detection

[![Dependency Status](https://gemnasium.com/mateomurphy/rails_locale_detection.png)](https://gemnasium.com/mateomurphy/rails_locale_detection)

Sets the current locale of a request using a combination of params, cookies, http headers, and an optional user object. 

In turn, it checks the value of params[:locale], cookies[:locale] and HTTP_ACCEPT_LANGUAGE headers to find a locale that
corresponds to the available locales, then stores the set locale in a cookie for future requests. If a user_locale method
is provided, the return value will be used, with preference over the other locale detection methods.

## Usage

Include the gem in your Gemfile 

    gem 'rails_locale_detection'
  
Set your default and available locales

    I18n.default_locale = :en
    I18n.available_locales = [:en, :fr]
  
Call set_locale as a filter in your controllers

    class ApplicationController < ActionController::Base
      before_filter :set_locale
    
    end

To support user locales, add a user_locale method

    class ApplicationController < ActionController::Base
      before_filter :set_locale

      def user_locale
        current_user.locale if current_user
      end
    
    end


## Configuration

The configuration options:

    Rails::LocaleDetection.config do |config|
      config.locale_expiry = 3.months # This sets how long the locale cookie lasts.
      config.set_default_url_option = true # sets the default_url_options[:locale] to the current locale when set_locale is called
      config.detection_order = [:user, :param, :cookie, :request] # set the order in which locale detection occurs. Omit values to skip those sources
    end

== Contributing to rails_locale_detection
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Mateo Murphy. See LICENSE.txt for
further details.

