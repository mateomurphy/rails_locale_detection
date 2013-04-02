module RailsLocaleDetection
  class Railtie < Rails::Railtie
    initializer "rails_locale_detection.append_before_filter" do
      ActiveSupport.on_load(:action_controller) do
        ActionController::Base.send :include, RailsLocaleDetection::ControllerMethods
      end
      
      ActiveSupport.on_load(:action_view) do
        ActionView::Base.send :include, Rails::LocaleDetection::LocaleAccessors
      end      
    end
  end
end