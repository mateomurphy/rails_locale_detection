module RailsLocaleDetection
  module ControllerMethods
    extend ActiveSupport::Concern
    include LocaleAccessors

    included do
      detect_locale if RailsLocaleDetection.automatically_detect
    end

    module ClassMethods
      if ::Rails.version.to_s < "4.0"
        def detect_locale
          append_before_filter LocaleDetector
        end
      else
        def detect_locale
          append_before_action LocaleDetector
        end
      end
    end

    def user_locale
      nil
    end
  end
end
