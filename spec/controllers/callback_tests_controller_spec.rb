require 'spec_helper'

describe CallbackTestsController do
  
  it "should automatically include the callback" do
    subject.class.ancestors.should include(RailsLocaleDetection::ControllerMethods)
  end
  
  it "should correctly detect the user locale" do
    get :show
    
    response.body.should eq('fr')
  end
  
end