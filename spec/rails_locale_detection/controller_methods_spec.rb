require 'spec_helper'

describe RailsLocaleDetection::ControllerMethods do
  let(:request) { MockRequest.new }
  let(:controller) { MockController.new(request) }

  describe '#available_locales' do
    it "shadows I18n.available_locales" do
      controller.available_locales.should eq([:en, :fr])
    end
  end

  describe '#default_locale' do
    it "shadows I18n.default locale"  do
      controller.default_locale.should eq(:en)
    end
  end
end
