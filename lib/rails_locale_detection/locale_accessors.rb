module RailsLocaleDetection
  module LocaleAccessors
    def alternate_locales
      available_locales - [current_locale]
    end

    def available_locales
      I18n.available_locales
    end

    def current_locale
      I18n.locale
    end
    
    def current_locale=(locale)
      I18n.locale = locale
    end

    def default_locale
      I18n.default_locale
    end
  end
end