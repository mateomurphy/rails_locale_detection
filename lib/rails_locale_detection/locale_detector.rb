module RailsLocaleDetection
  class LocaleDetector
    include DetectionMethods
    include LocaleAccessors

    attr_reader :controller

    delegate :params, :request, :default_url_options, :user_locale, :to => :controller

    def initialize(controller = nil)
      @controller = controller
    end

    def locale_key
      RailsLocaleDetection.locale_key
    end

    def cookies
      @controller.send(:cookies)
    end

    def self.before(controller)
      new(controller).set_locale
    end
  end
end
