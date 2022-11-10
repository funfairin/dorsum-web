require "redis"

module Dorsum
  module Oauth
    # Verifies the state returned alongside the authorization code.
    class Code
      def initialize(
        @redis : Redis::PooledClient,
        @config : Dorsum::Config,
        @params : URI::Params
      )
        @namespace = "dorsum:authorization"
      end

      def state
        @params["state"]
      end

      def code
        @params["code"]
      end

      def scope
        @params["scope"]
      end

      def verified?
        @redis.sismember("#{@namespace}:state", state) == 1
      end
    end
  end
end
