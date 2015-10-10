require 'spec_helper'

describe RailsLocaleDetection::ControllerMethods do
  let(:request) { MockRequest.new }
  subject(:controller) { MockController.new(request) }

  it 'provides a blank user locale method' do
    expect(controller.user_locale).to be_nil
  end

  it 'should provide a detect locale method' do
    expect(controller.class).to respond_to(:detect_locale)
  end

  it 'should add a before filter' do
    expect(controller.class.before_filters).to eq([[RailsLocaleDetection::LocaleDetector]])
  end

end
