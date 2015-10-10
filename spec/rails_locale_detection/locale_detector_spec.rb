require 'spec_helper'

describe RailsLocaleDetection::LocaleDetector do
  let(:request) { MockRequest.new }
  let(:controller) { MockController.new(request) }
  subject(:locale_detector) { RailsLocaleDetection::LocaleDetector.new(controller) }

  describe '#available_locales' do
    it "shadows I18n.available_locales" do
      expect(locale_detector.available_locales).to eq([:en, :fr])
    end
  end

  describe '#default_locale' do
    it "shadows I18n.default locale"  do
      expect(locale_detector.default_locale).to eq(:en)
    end
  end

  describe '#current_locale' do
    it "shadows I18n.locale"  do
      controller.params[:locale] = 'fr'
      locale_detector.set_locale
      expect(controller.current_locale).to eq(:fr)
    end
  end

  describe '#validate_locale' do
    it "returns the passed locale if it's valid" do
      expect(locale_detector.validate_locale(:en)).to eq(:en)
    end

    it "returns nil if the passed locale isn't valid" do
      expect(locale_detector.validate_locale(:es)).to be_nil
    end

    it "returns nil if nil is passed" do
      expect(locale_detector.validate_locale(nil)).to be_nil
    end
  end

  describe '#locale_from_param' do
    it "returns en if the param set was valid" do
      controller.params[:locale] = 'en'
      expect(locale_detector.locale_from_param).to eq(:en)
    end

    it "returns nil if the param set was not" do
      controller.params[:locale] = 'es'
      expect(locale_detector.locale_from_param).to be_nil
    end

    it "returns nil if not locale was set" do
      expect(locale_detector.locale_from_param).to be_nil
    end
  end

  describe '#locale_from_cookie' do
    it "returns en if the param set was valid" do
      controller.request.cookie_jar[:locale] = 'en'
      expect(locale_detector.locale_from_cookie).to eq(:en)
    end

    it "returns nil if the param set was not" do
      controller.request.cookie_jar[:locale] = 'es'
      expect(locale_detector.locale_from_cookie).to be_nil
    end

    it "returns nil if not locale was set" do
      expect(locale_detector.locale_from_cookie).to be_nil
    end
  end

  describe '#locale_from_request' do
    it "returns en if the param set was valid" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
      expect(locale_detector.locale_from_request).to eq(:en)
    end

    it "returns nil if the param set was not" do
      request.env['HTTP_ACCEPT_LANGUAGE'] = 'es'
      expect(locale_detector.locale_from_request).to be_nil
    end

    it "returns nil if not locale was set" do
      expect(locale_detector.locale_from_request).to be_nil
    end
  end

  describe '#locale_from_user' do
    it "returns the locale of the user if it's valid" do
      controller.user = MockUser.new(:en)
      expect(locale_detector.locale_from_user).to eq(:en)
    end

    it "returns nil if the locale of the use isn't valid" do
      controller.user = MockUser.new(:es)
      expect(locale_detector.locale_from_user).to be_nil
    end
  end

  describe '#locale_from' do
    before :each do
      controller.params[:locale] = 'en'
      controller.request.cookie_jar[:locale] = 'fr'
    end

    it "returns the locale set in the param" do
      expect(locale_detector.locale_from(:param)).to eq(:en)
    end

    it "return the locale set in the cookie" do
      expect(locale_detector.locale_from(:cookie)).to eq(:fr)
    end
  end

  describe '#detect_locale' do
    context "with default detection order" do
      before :each do
        RailsLocaleDetection.detection_order = [:user, :param, :cookie, :request]
      end

      it "returns default if nothing is set" do
        expect(locale_detector.detect_locale).to eq(:en)
      end

      it "returns en if the params is set to en" do
        controller.params[:locale] = "en"
        expect(locale_detector.detect_locale).to eq(:en)
      end

      it "returns fr if the cookie is set to fr" do
        controller.request.cookie_jar[:locale] = "fr"
        expect(locale_detector.detect_locale).to eq(:fr)
      end

      it "returns en if the request is set to en" do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
        expect(locale_detector.detect_locale).to eq(:en)
      end

      it "return fr if the user locale was set to fr" do
        controller.user = MockUser.new(:en)
        expect(locale_detector.detect_locale).to eq(:en)
      end

    end

    context "with a custom detection order" do
      before :each do
        RailsLocaleDetection.detection_order = [:user, :param, :request]
      end

      it "returns return default if nothing is set" do
        expect(locale_detector.detect_locale).to eq(:en)
      end

      it "returns en if the params is set to en" do
        controller.params[:locale] = "en"
        expect(locale_detector.detect_locale).to eq(:en)
      end

      it "skips cookie" do
        controller.request.cookie_jar[:locale] = "fr"
        expect(locale_detector.detect_locale).to eq(:en)
      end

      it "returns en if the request is set to en" do
        request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,en-gb;q=0.8,en;q=0.6'
        expect(locale_detector.detect_locale).to eq(:en)
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
        expect(locale_detector).to be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is fale' do
        RailsLocaleDetection.set_default_url_option = false
        expect(locale_detector).to_not be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :never' do
        RailsLocaleDetection.set_default_url_option = :never
        expect(locale_detector).to_not be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :always' do
        RailsLocaleDetection.set_default_url_option = :always
        expect(locale_detector).to be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :explicitly' do
        RailsLocaleDetection.set_default_url_option = :explicitly
        expect(locale_detector).to be_set_default_url_option_for_request
      end
    end

    context 'without a locale param' do
      before :each do
        controller.params[:locale] = nil
      end

      it 'return true when set_default_url_option is true' do
        RailsLocaleDetection.set_default_url_option = true
        expect(locale_detector).to be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is false' do
        RailsLocaleDetection.set_default_url_option = false
        expect(locale_detector).to_not be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :never' do
        RailsLocaleDetection.set_default_url_option = :never
        expect(locale_detector).to_not be_set_default_url_option_for_request
      end

      it 'return true when set_default_url_option is :always' do
        RailsLocaleDetection.set_default_url_option = :always
        expect(locale_detector).to be_set_default_url_option_for_request
      end

      it 'return false when set_default_url_option is :explicitly' do
        RailsLocaleDetection.set_default_url_option = :explicitly
        expect(locale_detector).to_not be_set_default_url_option_for_request
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
        expect(I18n.locale).to eq(:fr)
      end

      it "sets the language" do
        expect(controller.request.cookie_jar[:locale]).to eq(:fr)
      end

      it "sets the default_url_options" do
        expect(controller.default_url_options[:locale].to_s).to eq('fr')
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
        expect(I18n.locale).to eq(:fr)
      end

      it "sets the cookier locale" do
        expect(controller.request.cookie_jar[:locale]).to eq(:fr)
      end

      it "doesn't set the default_url_options" do
        expect(controller.default_url_options[:locale]).to be_nil
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
        expect(I18n.locale).to eq(:en)
      end

      it "sets the cookie locale" do
        expect(controller.request.cookie_jar[:locale]).to eq(:en)
      end

      it "doesn't set the default_url_options" do
        expect(controller.default_url_options[:locale]).to be_nil
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
        expect(I18n.locale).to eq(:fr)
      end

      it "sets the cookie locale" do
        expect(controller.request.cookie_jar[:locale]).to eq(:fr)
      end

      it "doesn't set the default_url_options" do
        expect(controller.default_url_options[:locale]).to eq(:fr)
      end
    end

  end

end
