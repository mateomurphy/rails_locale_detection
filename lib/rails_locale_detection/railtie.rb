# frozen_string_literal: true

module RailsLocaleDetection
  class Railtie < Rails::Railtie
    initializer "rails_locale_detection.include_controller_methods" do
      ActiveSupport.on_load(:action_controller_base) do
        include RailsLocaleDetection::ControllerMethods
      end

      ActiveSupport.on_load(:action_controller_api) do
        include RailsLocaleDetection::ControllerMethods
      end

      ActiveSupport.on_load(:action_view) do
        include RailsLocaleDetection::LocaleAccessors
      end
    end
  end
end
