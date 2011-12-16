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
  
    def validate_locale(locale)
      locale if locale && available_locales.include?(locale.to_sym)
    end
  
    def locale_from_param
      validate_locale(params[:locale])
    end
  
    def locale_from_cookies
      validate_locale(params[:locale])
    end  
  
    def locale_from_request
      request.preferred_language_from(available_locales)
    end
  
    def get_locale
      locale_from_param || locale_from_cookies || locale_from_request || default_locale
    end
    
    def set_locale
      I18n.locale = get_locale
      cookies[:locale] = { :value => I18n.locale, :expires => locale_expiry.from_now }
    end  
  end
end