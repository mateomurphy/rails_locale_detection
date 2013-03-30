require 'spec_helper'

describe FilterTestsController do
  
  it "should automatically include the filter" do
    subject.class.ancestors.should include(RailsLocaleDetection::Filter)
  end
  
  it "should correctly detect the user locale" do
    get :show
    
    response.body.should eq('fr')
  end
  
end