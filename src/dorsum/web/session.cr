require "uuid"

module Dorsum
  module Web
    class Session
      def initialize
        @uuid = UUID.generate
        @data = {} of String => String
      end

      def initialize(@uuid : String)
        @data = {} of String => String
      end

      def load(redis : Redis::PooledClient)
        @data = redis.hgetall("dorsum:session:#{@uuid}")
      end

      def save(redis : Redis::PooledClient)
        redis.hset("dorsum:session:#{@uuid}", @data.to_a)
      end

      def self.load(redis : Redis::PooledClient, uuid : String)
        session = new(uuid)
        session.load(redis)
        session
      end
    end
  end
end
