require 'spec_helper'

describe RailsLocaleDetection::ControllerMethods do
  let(:request) { MockRequest.new }
  subject(:controller) { MockController.new(request) }

  it 'provides a blank user locale method' do
    controller.user_locale.should be_nil
  end
  
  it 'should provide a detect locale method' do
    controller.class.should respond_to(:detect_locale)
  end 
  
  it 'should add a before filter' do
    controller.class.before_filters.should eq([[RailsLocaleDetection::LocaleDetector]])
  end
  
end
