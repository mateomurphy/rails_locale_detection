module Rails
  module LocaleDetection
    mattr_accessor :locale_expiry
    @@locale_expiry = 3.months
    
    mattr_accessor :set_default_url_option
    @@set_default_url_option = :always
    
    mattr_accessor :detection_order
    @@detection_order = [:user, :param, :cookie, :request]
    
    def self.config
      yield self
    end
    
    def available_locales
      I18n.available_locales
    end
  
    def default_locale
      I18n.default_locale
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
      detection_order.inject(nil) { |result, source| result || locale_from(source) } || default_locale
    end
    
    # returns true if the default url option should be set for this request
    def set_default_url_option_for_request?
      set_default_url_option === true || set_default_url_option == :always || set_default_url_option == :explicitly && params[:locale].present?
    end
    
    # set I18n.locale, default_url_options[:locale] and cookies[:locale] to the value returned by
    # get_locale
    def set_locale
      I18n.locale = get_locale
      
      default_url_options[:locale] = I18n.locale if set_default_url_option_for_request?
      
      cookies[:locale] = { :value => I18n.locale, :expires => locale_expiry.from_now }
      
      I18n.locale
    end  
  end
end