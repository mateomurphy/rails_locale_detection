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

  context 'when the rails is 4.0 or later' do
    before do
      skip "Rails version is #{::Rails.version.to_s}" unless ::Rails.version.to_s >= '4.0'
    end

    it 'adds the detector as a before action' do
      expect(controller.class.before_actions).to eq([[RailsLocaleDetection::LocaleDetector]])
    end
  end

  context 'when the rails is less than 4.0' do
    before do
      skip "Rails version is #{::Rails.version.to_s}" unless ::Rails.version.to_s < '4.0'
    end

    it 'adds the detector as a before filter' do
      expect(controller.class.before_filters).to eq([[RailsLocaleDetection::LocaleDetector]])
    end
  end
end
