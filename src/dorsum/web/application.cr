require "uri"
require "http/server/handler"

module Dorsum
  module Web
    class Application
      include HTTP::Handler

      def initialize(@redis : Redis::PooledClient, @config : Dorsum::Config)
      end

      def call(context)
        case context.request.resource
        when "/"
          Controllers::PagesController.new.index(context)
        when "/status"
          Controllers::StatusController.new.show(context)
        when "/session/new"
          Controllers::SessionsController.new.new(context)
        when "/twitch/oauth/session/new"
          Controllers::TwitchOauthSessionsController.new(@redis, @config).new(context)
        when %r{^/twitch/oauth/session}
          Controllers::TwitchOauthSessionsController.new(@redis, @config).create(context)
        else
          call_next(context)
        end
      end
    end
  end
end
