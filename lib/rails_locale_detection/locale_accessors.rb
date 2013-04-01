module RailsLocaleDetection
  module LocaleAccessors
    def available_locales
      I18n.available_locales
    end

    def default_locale
      I18n.default_locale
    end

    def current_locale
      I18n.locale
    end
    
    def current_locale=(locale)
      I18n.locale = locale
    end
  end
end