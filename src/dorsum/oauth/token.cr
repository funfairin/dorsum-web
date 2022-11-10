require "http"
require "redis"
require "json"

module Dorsum
  module Oauth
    # Value class and parser for an authorization token and its JSON.
    class Token
      def initialize(@attributes : JSON::Any)
      end

      def access_token
        @attributes["access_token"].as_s
      end

      def expires_in
        @attributes["expires_in"].as_i
      end

      def refresh_token
        @attributes["refresh_token"].as_s
      end

      def scope
        @attributes["scope"].as_a
      end

      def token_type
        @attributes["token_type"].as_s
      end

      def self.parse(json)
        new(JSON.parse(json))
      end
    end
  end
end
