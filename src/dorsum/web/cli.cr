require "log"
require "http/server"

module Dorsum
  module Web
    class Cli
      # Stores the context of the latest invocation of the command-line interface.
      getter context : Context
      # Manages the persistent configuration of the service on disk.
      getter config : Config

      def initialize
        @redis = Redis::PooledClient.new
        @context = Context.new
        @config = Config.load
        @config.port = "7744" unless @config.port?
      end

      def run(argv)
        OptionParser.parse(argv, context, config)
        if context.errors.any?
          print_errors
        elsif context.run?
          run_command
        end
      end

      def run_command
        case context.command
        when "config"
          config.save
        else
          run_forever
        end
      end

      private def run_forever
        Log.info { "Starting dorsum-web, listening on port #{@config.port}" }
        loop { run }
      end

      private def run
        server = HTTP::Server.new([
          HTTP::ErrorHandler.new,
          HTTP::LogHandler.new,
          HTTP::CompressHandler.new,
          HTTP::StaticFileHandler.new("public", true, false),
          Dorsum::Web::Application.new(@redis, @config),
        ])
        server.bind_tcp "127.0.0.1", @config.port.as_s.to_i
        server.listen
        # rescue e : Exception
        #   Log.warn { e.message }
        #   sleep
      end

      private def print_errors
        context.errors.each do |error|
          Log.fatal { error }
        end
      end
    end
  end
end
