# lib/api_client.rb

require 'httparty'

class ApiClient
  include HTTParty

  def initialize(url, password)
    @url = url
    @password = password
    @session = HTTParty::CookieHash.new
  end

  def is_logged_in?
    response = get_session
    response.parsed_response["authenticated"]
  end

  def url_builder(path)
    "#{@url}#{path}"
  end

  def login
    raise 'AlreadyLoggedInError' if is_logged_in?
    response = self.class.post(url_builder("/session"), body: { password: @password }.to_json, headers: { 'Content-Type' => 'application/json' })
    @session.add_cookies(response.headers['set-cookie'])
    response
  end

  def get_session
    self.class.get(url_builder("/session"), headers: { 'Cookie' => @session.to_cookie_string })
  end

  def get_clients
    self.class.get(url_builder("/wireguard/client"), headers: { 'Cookie' => @session.to_cookie_string })
  end
end
