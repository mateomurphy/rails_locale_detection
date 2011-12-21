require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

I18n.default_locale = :en
I18n.available_locales = [:en, :fr]
Timecop.freeze

describe Rails::LocaleDetection do
  let(:request) { MockRequest.new }
  let(:controller) { MockController.new(request) }
  
  describe '.locale_expiry' do
    it "is set to 3 months by default" do
      Rails::LocaleDetection.locale_expiry.should eq(3.months)
    end
  end
  
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
  
  describe '#validate_locale' do
    it "returns the passed locale if it's valid" do
      controller.validate_locale(:en).should eq(:en)
    end
    
    it "returns nil if the passed locale isn't valid" do
      controller.validate_locale(:es).should be_nil
    end
  end
  
  describe '#locale_from_param' do
    it "returns en if the param set was valid" do
      controller.params[:locale] = 'en'
      controller.locale_from_param.should eq(:en)
    end
    
    it "returns nil if the param set was not" do
      controller.params[:locale] = 'es'
      controller.locale_from_param.should be_nil
    end

    it "returns nil if not locale was set" do
      controller.locale_from_param.should be_nil
    end
  end
  
  describe '#locale_from_cookie' do
    it "returns en if the param set was valid" do
      controller.cookies[:locale] = 'en'
      controller.locale_from_cookies.should eq(:en)
    end
    
    it "returns nil if the param set was not" do
      controller.cookies[:locale] = 'es'
      controller.locale_from_cookies.should be_nil
    end

    it "returns nil if not locale was set" do
      controller.locale_from_cookies.should be_nil
    end
  end  
  
  describe '#locale_from_request' do
    it "returns en if the param set was valid" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
      controller.locale_from_request.should eq(:en)
    end
    
    it "returns nil if the param set was not" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es'
      controller.locale_from_request.should be_nil
    end

    it "returns nil if not locale was set" do
      controller.locale_from_request.should be_nil
    end
  end  
  
  describe '#get_locale' do
    it "returns nil if nothing is set" do
      controller.get_locale.should eq(:en)
    end

    it "returns en if the params is set to en" do
      controller.params[:locale] = "en"
      controller.get_locale.should eq(:en)
    end

    it "returns fr if the cookie is set to fr" do
      controller.cookies[:locale] = "fr"
      controller.get_locale.should eq(:fr)
    end

    it "returns en if the request is set to en" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
      controller.get_locale.should eq(:en)
    end
  end

  describe '#set_locale' do
    before :all do
      controller.params[:locale] = "fr"
      controller.set_locale
    end
    
    it "sets the current locale to the locale param" do
      I18n.locale.should eq(:fr)
    end
    
    it "sets the language" do
      controller.cookies[:locale].should eq(:fr)
    end
    
    it "sets the default_url_options" do
      controller.default_url_options[:locale].to_s.should eq('fr')
    end
  end
end
