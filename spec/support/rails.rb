class MockApplication
  def self.env_config
    {}
  end
  
  def self.routes
    @routes ||= ActionDispatch::Routing::RouteSet.new
  end
end

MockApplication.routes.draw do
  resource :filter_tests
end

::Rails.application = MockApplication

ActionController::Base.send :include, RailsLocaleDetection::Filter
ActionController::Base.send :include, Rails.application.routes.url_helpers  

class FilterTestsController < ActionController::Base

  def user_locale
    :fr
  end
  
  def show
    render :text => current_locale
  end
  
end