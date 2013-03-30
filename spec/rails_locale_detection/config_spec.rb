require 'spec_helper'

describe RailsLocaleDetection do

  describe '.locale_expiry' do
    it "is set to 3 months by default" do
      RailsLocaleDetection.config do |c|
        c.locale_expiry.should eq(3.months)
      end
    end
  end
end