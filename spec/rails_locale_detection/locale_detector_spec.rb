require 'spec_helper'

describe RailsLocaleDetection::LocaleDetector do
  let(:request) { MockRequest.new }
  let(:controller) { MockController.new(request) }
  subject(:locale_detector) { RailsLocaleDetection::LocaleDetector.new(controller) }

  describe '#available_locales' do
    it "shadows I18n.available_locales" do
      locale_detector.available_locales.should eq([:en, :fr])
    end
  end

  describe '#default_locale' do
    it "shadows I18n.default locale"  do
      locale_detector.default_locale.should eq(:en)
    end
  end

  describe '#current_locale' do
    it "shadows I18n.locale"  do
      controller.params[:locale] = 'fr'
      locale_detector.set_locale
      controller.current_locale.should eq(:fr)
    end
  end

  describe '#validate_locale' do
    it "returns the passed locale if it's valid" do
      locale_detector.validate_locale(:en).should eq(:en)
    end

    it "returns nil if the passed locale isn't valid" do
      locale_detector.validate_locale(:es).should be_nil
    end

    it "returns nil if nil is passed" do
      locale_detector.validate_locale(nil).should be_nil
    end
  end

  describe '#locale_from_param' do
    it "returns en if the param set was valid" do
      controller.params[:locale] = 'en'
      locale_detector.locale_from_param.should eq(:en)
    end

    it "returns nil if the param set was not" do
      controller.params[:locale] = 'es'
      locale_detector.locale_from_param.should be_nil
    end

    it "returns nil if not locale was set" do
      locale_detector.locale_from_param.should be_nil
    end
  end

  describe '#locale_from_cookie' do
    it "returns en if the param set was valid" do
      controller.request.cookie_jar[:locale] = 'en'
      locale_detector.locale_from_cookie.should eq(:en)
    end

    it "returns nil if the param set was not" do
      controller.request.cookie_jar[:locale] = 'es'
      locale_detector.locale_from_cookie.should be_nil
    end

    it "returns nil if not locale was set" do
      locale_detector.locale_from_cookie.should be_nil
    end
  end

  describe '#locale_from_request' do
    it "returns en if the param set was valid" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
      locale_detector.locale_from_request.should eq(:en)
    end

    it "returns nil if the param set was not" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es'
      locale_detector.locale_from_request.should be_nil
    end

    it "returns nil if not locale was set" do
      locale_detector.locale_from_request.should be_nil
    end
  end

  describe '#locale_from_user' do
    it "returns the locale of the user if it's valid" do
      controller.user = MockUser.new(:en)
      locale_detector.locale_from_user.should eq(:en)
    end

    it "returns nil if the locale of the use isn't valid" do
      controller.user = MockUser.new(:es)
      locale_detector.locale_from_user.should be_nil
    end
  end

  describe '#locale_from' do
    before :each do
      controller.params[:locale] = 'en'
      controller.request.cookie_jar[:locale] = 'fr'
    end

    it "returns the locale set in the param" do
      locale_detector.locale_from(:param).should eq(:en)
    end

    it "return the locale set in the cookie" do
      locale_detector.locale_from(:cookie).should eq(:fr)
    end
  end

  describe '#detect_locale' do
    context "with default detection order" do
      before :each do
        RailsLocaleDetection.detection_order = [:user, :param, :cookie, :request]
      end

      it "returns default if nothing is set" do
        locale_detector.detect_locale.should eq(:en)
      end

      it "returns en if the params is set to en" do
        controller.params[:locale] = "en"
        locale_detector.detect_locale.should eq(:en)
      end

      it "returns fr if the cookie is set to fr" do
        controller.request.cookie_jar[:locale] = "fr"
        locale_detector.detect_locale.should eq(:fr)
      end

      it "returns en if the request is set to en" do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
        locale_detector.detect_locale.should eq(:en)
      end

      it "return fr if the user locale was set to fr" do
        controller.user = MockUser.new(:en)
        locale_detector.detect_locale.should eq(:en)
      end

    end

    context "with a custom detection order" do
      before :each do
        RailsLocaleDetection.detection_order = [:user, :param, :request]
      end

      it "returns return default if nothing is set" do
        locale_detector.detect_locale.should eq(:en)
      end

      it "returns en if the params is set to en" do
        controller.params[:locale] = "en"
        locale_detector.detect_locale.should eq(:en)
      end

      it "skips cookie" do
        controller.request.cookie_jar[:locale] = "fr"
        locale_detector.detect_locale.should eq(:en)
      end

      it "returns en if the request is set to en" do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
        locale_detector.detect_locale.should eq(:en)
      end

    end

  end

  describe '#set_default_url_option_for_request?' do
    context 'with a locale param' do
      before :each do
        controller.params[:locale] = "fr"
      end

      it 'return true when set_default_url_option is true' do
        RailsLocaleDetection.set_default_url_option = true
        locale_detector.should be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is fale' do
        RailsLocaleDetection.set_default_url_option = false
        locale_detector.should_not be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :never' do
        RailsLocaleDetection.set_default_url_option = :never
        locale_detector.should_not be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :always' do
        RailsLocaleDetection.set_default_url_option = :always
        locale_detector.should be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :explicitly' do
        RailsLocaleDetection.set_default_url_option = :explicitly
        locale_detector.should be_set_default_url_option_for_request
      end
    end

    context 'without a locale param' do
      before :each do
        controller.params[:locale] = nil
      end

      it 'return true when set_default_url_option is true' do
        RailsLocaleDetection.set_default_url_option = true
        locale_detector.should be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is false' do
        RailsLocaleDetection.set_default_url_option = false
        locale_detector.should_not be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :never' do
        RailsLocaleDetection.set_default_url_option = :never
        locale_detector.should_not be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :always' do
        RailsLocaleDetection.set_default_url_option = :always
        locale_detector.should be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :explicitly' do
        RailsLocaleDetection.set_default_url_option = :explicitly
        locale_detector.should_not be_set_default_url_option_for_request
      end
    end

  end

  describe '#set_locale' do
    context "with set default_url_option :always" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :always
        controller.params[:locale] = "fr"
        locale_detector.set_locale
      end

      it "sets the current locale to the locale param" do
        I18n.locale.should eq(:fr)
      end

      it "sets the language" do
        controller.request.cookie_jar[:locale].should eq(:fr)
      end

      it "sets the default_url_options" do
        controller.default_url_options[:locale].to_s.should eq('fr')
      end
    end

    context "with set default_url_option :never" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :never
        controller.default_url_options = {}
        controller.params[:locale] = "fr"
        locale_detector.set_locale
      end

      it "sets the current locale to the locale param" do
        I18n.locale.should eq(:fr)
      end

      it "sets the cookier locale" do
        controller.request.cookie_jar[:locale].should eq(:fr)
      end

      it "doesn't set the default_url_options" do
        controller.default_url_options[:locale].should be_nil
      end
    end

    context "with set default_url_option :explicit and no locale param" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :explicitly
        controller.default_url_options = {}
        controller.params[:locale] = nil
        locale_detector.set_locale
      end

      it "sets the current locale to the default param" do
        I18n.locale.should eq(:en)
      end

      it "sets the cookie locale" do
        controller.request.cookie_jar[:locale].should eq(:en)
      end

      it "doesn't set the default_url_options" do
        controller.default_url_options[:locale].should be_nil
      end
    end

    context "with set default_url_option :explicit and a locale param" do
      before :each do
        RailsLocaleDetection.set_default_url_option = :explicitly
        controller.default_url_options = {}
        controller.params[:locale] = :fr
        locale_detector.set_locale
      end

      it "sets the current locale to the default param" do
        I18n.locale.should eq(:fr)
      end

      it "sets the cookie locale" do
        controller.request.cookie_jar[:locale].should eq(:fr)
      end

      it "doesn't set the default_url_options" do
        controller.default_url_options[:locale].should eq(:fr)
      end
    end

  end

end
