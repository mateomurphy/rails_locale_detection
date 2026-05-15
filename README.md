# rails_locale_detection

[![CI](https://github.com/mateomurphy/rails_locale_detection/actions/workflows/ci.yml/badge.svg)](https://github.com/mateomurphy/rails_locale_detection/actions/workflows/ci.yml)

**Compatibility:** Rails 6.1–8.0, Ruby 3.1+

Sets the current locale of a request using a combination of params, cookies, http headers, and an optional user object.

In turn, it checks the value of `params[:locale]`, `cookies[:locale]` and `HTTP_ACCEPT_LANGUAGE` headers to find a locale that
corresponds to the available locales, then stores the locale in a cookie for future requests. If a `user_locale` method
is provided, any valid return value will be used, with preference over the other locale detection methods except for `params[:locale]`.

## Usage

Include the gem in your Gemfile

    gem 'rails_locale_detection'

Set your default and available locales

    I18n.default_locale = :en
    I18n.available_locales = [:en, :fr]

To support user locales, add a `user_locale` method

    class ApplicationController < ActionController::Base
      def user_locale
        current_user.locale if current_user
      end
    end

Methods for accessing `current_locale`, `available_locales`, and `alternate_locales` are available in controller and views.

Works with both `ActionController::Base` and `ActionController::API` controllers.

## Configuration

Configuration is done via a block that can be added as an initializer:

    RailsLocaleDetection.config do |config|
      config.locale_expiry = 3.months
      config.set_default_url_option = :always # valid values are true, false, :always, :never and :explicitly
      config.detection_order = [:param, :user, :cookie, :request]
      config.automatically_detect = true
      config.locale_key = :locale
    end

The configuration options:

* `locale_expiry` sets how long the locale cookie lasts.
* `set_default_url_option` determines under which conditions the `default_url_option` is set
  * `true` or `:always` sets the option on all requests
  * `false` or `:never` never sets the option
  * `:explicitly` sets the option only when a `params[:locale]` is present
* `detection_order` set the order in which locale detection occurs. Omit values to skip those sources
* `automatically_detect` configures automatic inclusion of the detection callback.
    You can set this to false and include the callback yourself by calling `detect_locale` in your controller as required.
* `locale_key` configures the key used for `param` and `cookie`

## Changelog

See [CHANGELOG.md](CHANGELOG.md).

## Contributing to rails_locale_detection

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012-present Mateo Murphy. See LICENSE.txt for
further details.

