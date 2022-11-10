require "option_parser"

module Dorsum
  module Web
    class OptionParser
      def self.parse(argv, context : Dorsum::Web::Context, config : Dorsum::Config)
        ::OptionParser.parse(argv) do |parser|
          parser.banner = "Usage: dorsum-web [options]"
          parser.separator ""
          parser.separator "Commands:"

          parser.on("config", "Update configuration and write it to disk.") do
            context.command = "config"

            parser.on("--port PORT", "Port to listen on for HTTP traffic.") do |port|
              config.port = port
            end
            parser.on("--client-id CLIENT-ID", "Twitch application client ID") do |client_id|
              if client_id.empty?
                context.errors << "Please specify a Twitch application client ID."
              else
                config.client_id = client_id
              end
            end
            parser.on("--client-secret CLIENT-SECRET", "Twitch application client secret") do |client_secret|
              if client_secret.empty?
                context.errors << "Please specify a Twitch application client secret."
              else
                config.client_secret = client_secret
              end
            end
          end

          parser.on("--verbose", "Turn on debug logging.") do
            Log.setup(:debug)
          end

          parser.on("-h", "--help", "Show this help") do
            context.run = false
            puts parser
          end
        end
      end
    end
  end
end
