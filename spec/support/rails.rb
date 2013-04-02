class MockApplication
  def self.env_config
    {}
  end
  
  def self.routes
    @routes ||= ActionDispatch::Routing::RouteSet.new
  end
end

MockApplication.routes.draw do
  resource :callback_tests
end

::Rails.application = MockApplication

ActionController::Base.send :include, RailsLocaleDetection::ControllerMethods
ActionController::Base.send :include, Rails.application.routes.url_helpers  

class CallbackTestsController < ActionController::Base

  def user_locale
    :fr
  end
  
  def show
    render :text => current_locale
  end
  
end