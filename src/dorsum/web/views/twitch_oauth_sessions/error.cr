require "ecr"

module Dorsum
  module Web
    module Views
      module TwitchOauthSessions
        class Error
          ECR.def_to_s "#{__DIR__}/error.ecr"
        end
      end
    end
  end
end
