require "redis"

module Dorsum
  module Oauth
    # Builds a request URL to start the authorization flow.
    class Authorization
      BASE_URL = "#{Oauth::BASE_URL}/oauth2/authorize"
      getter state : String

      def initialize(
        @redis : Redis::PooledClient,
        @config : Dorsum::Config,
        @redirect_uri : String,
        @scopes : Array(String)
      )
        @namespace = "dorsum:authorization"
        @state = create_state
      end

      def params
        {
          client_id:     @config.client_id.as_s,
          redirect_uri:  @redirect_uri,
          response_type: "code",
          scope:         @scopes.join(" "),
          state:         @state,
        }
      end

      def query
        URI::Params.encode(params)
      end

      def url
        "#{BASE_URL}?#{query}"
      end

      private def create_state : String
        state = Random::Secure.hex
        @redis.sadd("#{@namespace}:state", state)
        state
      end
    end
  end
end
