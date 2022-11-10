module Dorsum
  module Web
    module Controllers
      class TwitchOauthSessionsController
        include Concerns::Session

        def initialize(@redis : Redis::PooledClient, @config : Dorsum::Config)
        end

        def new(context)
          redirect_uri = "http://#{context.request.headers["Host"]}/twitch/oauth/session"
          authorization = Dorsum::Oauth::Authorization.new(
            @redis, @config, redirect_uri, [] of String
          )
          context.response.status = HTTP::Status::FOUND
          context.response.headers["Location"] = authorization.url
          context.response.close
        end

        def create(context)
          code = Dorsum::Oauth::Code.new(
            @redis, @config, context.request.query_params
          )
          if code.verified?
            redirect_uri = "http://#{context.request.headers["Host"]}/twitch/oauth/token"
            token_request = Dorsum::Oauth::TokenRequest.new(
              @redis, @config, redirect_uri, code
            )
            if token_request.perform
              # TODO: store access token in Redis
              # TODO: store application session in Redis identified by a hex or something
              # TODO: set our own session cookie
              context.response.status = HTTP::Status::FOUND
              context.response.headers["Location"] = "/"
            else
              # TODO: show error!
              HTTP::Status::OK
            end
          else
            context.response.status = HTTP::Status::OK
            context.response.headers["Content-Type"] = "text/html; charset=utf-8"
            context.response.headers["X-Permitted-Cross-Domain-Policies"] = "none"
            context.response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
            context.response.headers["Content-Security-Policy"] = "default-src 'self'; object-src 'none'; script-src 'self'"
            Dorsum::Web::Views::Layouts::Application.new("Dorsum") do
              Dorsum::Web::Views::TwitchOauthSessions::Error.new.to_s(context.response)
            end.to_s(context.response)
          end
          context.response.close
        end
      end
    end
  end
end
