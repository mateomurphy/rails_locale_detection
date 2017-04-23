module RailsLocaleDetection
  module DetectionMethods
    # returns the (symbolized) value passed if it's in the available_locales
    def validate_locale(locale)
      locale.to_sym if locale && available_locales.include?(locale.to_sym)
    end

    def locale_from_param
      validate_locale(params[locale_key])
    end

    def locale_from_cookie
      validate_locale(cookies[locale_key])
    end

    def locale_from_request
      validate_locale(http_accept_language.preferred_language_from(available_locales))
    end

    def locale_from_user
      validate_locale(user_locale)
    end

    def locale_from(key)
      send("locale_from_#{key}")
    end

    def detect_locale
      RailsLocaleDetection.detection_order.inject(nil) { |result, source| result || locale_from(source) } || default_locale
    end

    # set I18n.locale, default_url_options[:locale] and cookies[:locale]
    # to the value returned by detect_locale
    def set_locale
      self.current_locale = detect_locale

      if set_default_url_option_for_request?
        default_url_options[locale_key] = current_locale
      end

      if locale_from_cookie != current_locale
        cookies[locale_key] = {
          :value => current_locale,
          :expires => RailsLocaleDetection.locale_expiry.from_now
        }
      end
    end

    # returns true if the default url option should be set for this request
    def set_default_url_option_for_request?
      RailsLocaleDetection.set_default_url_option === true || RailsLocaleDetection.set_default_url_option == :always || RailsLocaleDetection.set_default_url_option == :explicitly && params[locale_key].present?
    end
  end
end