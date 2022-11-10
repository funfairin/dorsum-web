require "ecr"

module Dorsum
  module Web
    module Views
      module Layouts
        class Application
          def initialize(@title : String, &block)
            @content = block
          end

          ECR.def_to_s "#{__DIR__}/application.ecr"
        end
      end
    end
  end
end
