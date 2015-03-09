require 'uri'
require 'net/http'
require 'json'

class WatchNext::MyshowsClient
  API_ROOT = URI("http://api.myshows.ru")

  class ApiError < StandardError
    def initialize(response, *args)
      @response = response
      super(*args)
    end

    def message
      "#{super} (http status: #{@response.code} #{@response.message})"
    end
  end

  class NotAuthorizedError < ApiError; end
  class AuthenticationError < ApiError; end

  def initialize
    @cookies = ""
  end

  def authenticate(username, password_hash)
    response = get("/profile/login",
                   login: username,
                   password: password_hash)

    case response
    when Net::HTTPForbidden
      raise AuthenticationError.new(response)
    when Net::HTTPSuccess
      @cookies = response["set-cookie"].to_s
      true
    end
  end

  def unwatched_episodes
    response = get("/profile/episodes/unwatched/")

    case response
    when Net::HTTPUnauthorized
      raise NotAuthorizedError.new(response)
    when Net::HTTPSuccess
      JSON.parse(response.body)
    end
  end

  def shows
    response = get("/profile/shows/")

    case response
    when Net::HTTPUnauthorized
      raise NotAuthorizedError.new(response)
    when Net::HTTPSuccess
      JSON.parse(response.body)
    end
  end

  private

  def get(path, query_params = {})
    unless query_params.empty?
      path = [path, URI.encode_www_form(query_params)].join("?")
    end

    request = Net::HTTP::Get.new(path)
    request["Accept"] = "application/json"
    request["Cookie"] = @cookies

    response = nil
    http.start { |h| response = h.request(request) }
    response
  end

  def http
    @http ||= Net::HTTP.new(API_ROOT.host, API_ROOT.port)
  end
end
