require 'spec_helper'

class AccessorTest
  include RailsLocaleDetection::LocaleAccessors
end

describe RailsLocaleDetection::LocaleAccessors do
  subject :object do
    AccessorTest.new
  end
  
  describe '#alternate_locales' do
    it "returns all available locales minus the current one" do
      object.current_locale = :en
      object.alternate_locales.should eq([:fr])
    end
  end

  describe '#available_locales' do
    it "shadows I18n.available_locales" do
      object.available_locales.should eq([:en, :fr])
    end
  end

  describe '#default_locale' do
    it "shadows I18n.default locale"  do
      object.default_locale.should eq(:en)
    end
  end
end
