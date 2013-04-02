require 'spec_helper'

describe RailsLocaleDetection do
  describe 'backwards compatility' do
    it 'should be possible to configure using the previous module name' do
      Rails::LocaleDetection.should respond_to(:config)
    end
  end
  
  describe '.locale_expiry' do
    it "is set to 3 months by default" do
      RailsLocaleDetection.config do |c|
        c.locale_expiry.should eq(3.months)
      end
    end
  end
end