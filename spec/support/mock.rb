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

class MockController
  include Rails::LocaleDetection
  
  attr_accessor :request, :params, :cookies, :default_url_options, :user
  
  def initialize(request)
    @request = request
    @cookies = ActionDispatch::Cookies::CookieJar.build(request)
    @default_url_options = @params = {}
  end
  
  def user_locale
    return user.locale if user
  end
end

class MockUser
  attr_accessor :locale
  
  def initialize(locale)
    @locale = locale
  end
end
