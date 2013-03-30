module RailsLocaleDetection
  module Filter
    extend ActiveSupport::Concern

    included do
      append_before_filter :set_locale
    end

    def available_locales
      I18n.available_locales
    end

    def default_locale
      I18n.default_locale
    end

    def current_locale
      I18n.locale
    end

    def user_locale
      nil
    end

    # returns the (symbolized) value passed if it's in the available_locales
    def validate_locale(locale)
      locale.to_sym if locale && available_locales.include?(locale.to_sym)
    end

    def locale_from_param
      validate_locale(params[:locale])
    end

    def locale_from_cookie
      validate_locale(cookies[:locale])
    end

    def locale_from_request
      validate_locale(request.preferred_language_from(available_locales))
    end

    def locale_from_user
      validate_locale(user_locale)
    end

    def locale_from(key)
      send("locale_from_#{key}")
    end

    def get_locale
      RailsLocaleDetection.detection_order.inject(nil) { |result, source| result || locale_from(source) } || default_locale
    end

    # set I18n.locale, default_url_options[:locale] and cookies[:locale] to the value returned by
    # get_locale
    def set_locale
      I18n.locale = get_locale
      default_url_options[:locale] = I18n.locale if set_default_url_option_for_request?
      cookies[:locale] = { :value => I18n.locale, :expires => RailsLocaleDetection.locale_expiry.from_now }
    end

    protected

    # returns true if the default url option should be set for this request
    def set_default_url_option_for_request?
      RailsLocaleDetection.set_default_url_option === true || RailsLocaleDetection.set_default_url_option == :always || RailsLocaleDetection.set_default_url_option == :explicitly && params[:locale].present?
    end
  end
end