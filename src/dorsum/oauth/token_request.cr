require "http"
require "redis"

module Dorsum
  module Oauth
    # Requests an access token using the authorization code.
    class TokenRequest
      BASE_URL = "#{Oauth::BASE_URL}/oauth2/token"

      getter code : Dorsum::Oauth::Code
      getter response : (HTTP::Client::Response | Nil)

      def initialize(
        @redis : Redis::PooledClient,
        @config : Dorsum::Config,
        @redirect_uri : String,
        @code : Dorsum::Oauth::Code
      )
        @namespace = "dorsum:authorization"
        @response = nil
      end

      def params
        {
          client_id:     @config.client_id.as_s,
          client_secret: @config.client_secret.as_s,
          code:          @code.code,
          grant_type:    "authorization_code",
          redirect_uri:  @redirect_uri,
        }
      end

      def query
        URI::Params.encode(params)
      end

      def perform : Bool
        @response = HTTP::Client.post(BASE_URL, body: query)
        @response.as(HTTP::Client::Response).success?
      end
    end
  end
end
