class MockRequest
  include HttpAcceptLanguage

  attr_accessor :env, :cookies, :cookie_jar

  def initialize
    @env = {'HTTP_ACCEPT_LANGUAGE' => ''}
    @cookies = {}
    @cookie_jar = ActionDispatch::Cookies::CookieJar.build(self, @cookies)
  end

  def host
    "localhost"
  end

  def ssl?
    false
  end

  def cookies_same_site_protection
    proc { nil }
  end
end

class MockUser
  attr_accessor :locale

  def initialize(locale)
    @locale = locale
  end
end

class MockController

  attr_accessor :request, :params, :default_url_options, :user

  def initialize(request)
    @request = request
    @default_url_options = @params = {}
  end

  def user_locale
    return user.locale if user
  end

  class << self
    attr_reader :before_actions
  end

  def self.append_before_action(*args)
    @before_actions ||= []
    @before_actions << args
  end

  include RailsLocaleDetection::ControllerMethods
  include HttpAcceptLanguage::EasyAccess
end
