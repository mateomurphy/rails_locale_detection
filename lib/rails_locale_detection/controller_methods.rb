module RailsLocaleDetection
  module ControllerMethods
    extend ActiveSupport::Concern
    include LocaleAccessors

    included do
      detect_locale if RailsLocaleDetection.automatically_detect
    end

    module ClassMethods
      def detect_locale
        prepend_before_filter LocaleDetector
      end
    end

    def user_locale
      nil
    end
  end
end