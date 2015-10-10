require 'spec_helper'

describe RailsLocaleDetection do
  describe 'backwards compatility' do
    it 'should be possible to configure using the previous module name' do
      expect(Rails::LocaleDetection).to respond_to(:config)
    end
  end

  describe '.locale_expiry' do
    it "is set to 3 months by default" do
      RailsLocaleDetection.config do |c|
        expect(c.locale_expiry).to eq(3.months)
      end
    end
  end
end