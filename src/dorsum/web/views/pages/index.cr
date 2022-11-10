require "ecr"

module Dorsum
  module Web
    module Views
      module Pages
        class Index
          ECR.def_to_s "#{__DIR__}/index.ecr"
        end
      end
    end
  end
end
