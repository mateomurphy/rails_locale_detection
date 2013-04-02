module Rails
  module LocaleDetection
    class Railtie < Rails::Railtie
      initializer "rails_locale_detection.append_before_filter" do
        ActiveSupport.on_load(:action_controller) do
          ActionController::Base.send :include, Rails::LocaleDetection::Filter
        end
        ActiveSupport.on_load(:action_view) do
          ActionView::Base.send :include, Rails::LocaleDetection::InternationalizationHelper
        end
      end
    end
  end
end