class MockRequest
  include HttpAcceptLanguage
  
  attr_accessor :env
  
  def initialize
    @env = {'HTTP_ACCEPT_LANGUAGE' => ''}
  end
end

class MockController
  include Rails::LocaleDetection
  
  attr_accessor :request, :params, :cookies, :default_url_options
  
  def initialize(request)
    @request = request
    @cookies = ActionDispatch::Cookies::CookieJar.new
    @default_url_options = @params = {}
  end
end