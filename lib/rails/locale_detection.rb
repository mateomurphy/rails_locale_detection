module Rails
  module LocaleDetection
    mattr_accessor :locale_expiry
    @@locale_expiry = 3.months
    
    def available_locales
      I18n.available_locales
    end
  
    def default_locale
      I18n.default_locale
    end
  
    # returns the (symbolized) value passed if it's in the available_locales
    def validate_locale(locale)
      locale.to_sym if locale && available_locales.include?(locale.to_sym)
    end
  
    def locale_from_param
      validate_locale(params[:locale])
    end
  
    def locale_from_cookies
      validate_locale(cookies[:locale])
    end  
  
    def locale_from_request
      validate_locale(request.preferred_language_from(available_locales))
    end
  
    def get_locale
      locale_from_param || locale_from_cookies || locale_from_request || default_locale
    end
    
    # set I18n.locale, default_url_options[:locale] and cookies[:locale] to the value returned by
    # get_locale
    def set_locale
      default_url_options[:locale] = I18n.locale = get_locale
      
      cookies[:locale] = { :value => I18n.locale, :expires => locale_expiry.from_now }
      
      I18n.locale
    end  
  end
end