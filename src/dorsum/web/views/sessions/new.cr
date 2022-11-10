require "ecr"

module Dorsum
  module Web
    module Views
      module Sessions
        class New
          ECR.def_to_s "#{__DIR__}/new.ecr"
        end
      end
    end
  end
end
