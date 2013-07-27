class MockRequest
  include HttpAcceptLanguage

  attr_accessor :env

  def initialize
    @env = {'HTTP_ACCEPT_LANGUAGE' => ''}
  end

  def host
    "localhost"
  end

  def ssl?
    false
  end

  def cookies
    {}
  end
end

class MockUser
  attr_accessor :locale

  def initialize(locale)
    @locale = locale
  end
end

class MockController

  attr_accessor :request, :params, :cookies, :default_url_options, :user

  def initialize(request)
    @request = request
    @cookies = ActionDispatch::Cookies::CookieJar.build(request)
    @default_url_options = @params = {}
  end

  def user_locale
    return user.locale if user
  end

  class << self
    attr_reader :before_filters
  end

  def self.before_filter(*args)
    @before_filters ||= []
    @before_filters << args
  end

  def self.append_before_filter(*args)
    @before_filters ||= []
    @before_filters << args
  end

  def self.prepend_before_filter(*args)
    @before_filters ||= []
    @before_filters << args
  end

  include RailsLocaleDetection::ControllerMethods

end
