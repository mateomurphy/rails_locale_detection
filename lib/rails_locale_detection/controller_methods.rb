module RailsLocaleDetection
  module ControllerMethods
    extend ActiveSupport::Concern
    include DetectionMethods
    include LocaleAccessors

    included do
      append_before_filter LocaleDetector
    end

    def user_locale
      nil
    end
  end
end