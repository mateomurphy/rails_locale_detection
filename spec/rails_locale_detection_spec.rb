require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

I18n.default_locale = :en
I18n.available_locales = [:en, :fr]
Timecop.freeze

describe Rails::LocaleDetection do
  let(:request) { MockRequest.new }
  let(:controller) { MockController.new(request) }

  describe '.locale_expiry' do
    it "is set to 3 months by default" do
      Rails::LocaleDetection.config do |c|
        c.locale_expiry.should eq(3.months)
      end
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

  describe '#current_locale' do
    it "shadows I18n.locale"  do
      controller.params[:locale] = 'fr'
      controller.set_locale
      controller.current_locale.should eq(:fr)
    end
  end

  describe '#validate_locale' do
    it "returns the passed locale if it's valid" do
      controller.validate_locale(:en).should eq(:en)
    end

    it "returns nil if the passed locale isn't valid" do
      controller.validate_locale(:es).should be_nil
    end

    it "returns nil if nil is passed" do
      controller.validate_locale(nil).should be_nil
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
      controller.locale_from_cookie.should eq(:en)
    end

    it "returns nil if the param set was not" do
      controller.cookies[:locale] = 'es'
      controller.locale_from_cookie.should be_nil
    end

    it "returns nil if not locale was set" do
      controller.locale_from_cookie.should be_nil
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

  describe '#locale_from_user' do
    it "returns the locale of the user if it's valid" do
      controller.user = MockUser.new(:en)
      controller.locale_from_user.should eq(:en)
    end

    it "returns nil if the locale of the use isn't valid" do
      controller.user = MockUser.new(:es)
      controller.locale_from_user.should be_nil
    end
  end

  describe '#locale_from' do
    before :all do
      controller.params[:locale] = 'en'
      controller.cookies[:locale] = 'fr'
    end

    it "returns the locale set in the param" do
      controller.locale_from(:param).should eq(:en)
    end

    it "return the locale set in the cookie" do
      controller.locale_from(:cookie).should eq(:fr)
    end
  end

  describe '#get_locale' do
    context "with default detection order" do
      before :all do
        Rails::LocaleDetection.detection_order = [:user, :param, :cookie, :request]
      end

      it "returns default if nothing is set" do
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

      it "return fr if the user locale was set to fr" do
        controller.user = MockUser.new(:en)
        controller.get_locale.should eq(:en)
      end

    end

    context "with a custom detection order" do
      before :all do
        Rails::LocaleDetection.detection_order = [:user, :param, :request]
      end

      it "returns return default if nothing is set" do
        controller.get_locale.should eq(:en)
      end

      it "returns en if the params is set to en" do
        controller.params[:locale] = "en"
        controller.get_locale.should eq(:en)
      end

      it "skips cookie" do
        controller.cookies[:locale] = "fr"
        controller.get_locale.should eq(:en)
      end

      it "returns en if the request is set to en" do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
        controller.get_locale.should eq(:en)
      end

    end

  end

  describe '#set_default_url_option_for_request?' do
    context 'with a locale param' do
      before :all do
        controller.params[:locale] = "fr"
      end

      it 'return true when set_default_url_option is true' do
        Rails::LocaleDetection.set_default_url_option = true
        controller.should be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is fale' do
        Rails::LocaleDetection.set_default_url_option = false
        controller.should_not be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :never' do
        Rails::LocaleDetection.set_default_url_option = :never
        controller.should_not be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :always' do
        Rails::LocaleDetection.set_default_url_option = :always
        controller.should be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :explicitly' do
        Rails::LocaleDetection.set_default_url_option = :explicitly
        controller.should be_set_default_url_option_for_request
      end
    end

    context 'without a locale param' do
      before :all do
        controller.params[:locale] = nil
      end

      it 'return true when set_default_url_option is true' do
        Rails::LocaleDetection.set_default_url_option = true
        controller.should be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is false' do
        Rails::LocaleDetection.set_default_url_option = false
        controller.should_not be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :never' do
        Rails::LocaleDetection.set_default_url_option = :never
        controller.should_not be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :always' do
        Rails::LocaleDetection.set_default_url_option = :always
        controller.should be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :explicitly' do
        Rails::LocaleDetection.set_default_url_option = :explicitly
        controller.should_not be_set_default_url_option_for_request
      end
    end

  end

  describe '#set_locale' do
    context "with set default_url_option :always" do
      before :all do
        Rails::LocaleDetection.set_default_url_option = :always
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

    context "with set default_url_option :never" do
      before :all do
        Rails::LocaleDetection.set_default_url_option = :never
        controller.default_url_options = {}
        controller.params[:locale] = "fr"
        controller.set_locale
      end

      it "sets the current locale to the locale param" do
        I18n.locale.should eq(:fr)
      end

      it "sets the cookier locale" do
        controller.cookies[:locale].should eq(:fr)
      end

      it "doesn't set the default_url_options" do
        controller.default_url_options[:locale].should be_nil
      end
    end

    context "with set default_url_option :explicit and no locale param" do
      before :all do
        Rails::LocaleDetection.set_default_url_option = :explicitly
        controller.default_url_options = {}
        controller.params[:locale] = nil
        controller.set_locale
      end

      it "sets the current locale to the default param" do
        I18n.locale.should eq(:en)
      end

      it "sets the cookie locale" do
        controller.cookies[:locale].should eq(:en)
      end

      it "doesn't set the default_url_options" do
        controller.default_url_options[:locale].should be_nil
      end
    end

    context "with set default_url_option :explicit and a locale param" do
      before :all do
        Rails::LocaleDetection.set_default_url_option = :explicitly
        controller.default_url_options = {}
        controller.params[:locale] = :fr
        controller.set_locale
      end

      it "sets the current locale to the default param" do
        I18n.locale.should eq(:fr)
      end

      it "sets the cookie locale" do
        controller.cookies[:locale].should eq(:fr)
      end

      it "doesn't set the default_url_options" do
        controller.default_url_options[:locale].should eq(:fr)
      end
    end

  end

end
