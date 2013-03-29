require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Rails::LocaleDetection do

  describe '.locale_expiry' do
    it "is set to 3 months by default" do
      Rails::LocaleDetection.config do |c|
        c.locale_expiry.should eq(3.months)
      end
    end
  end

end