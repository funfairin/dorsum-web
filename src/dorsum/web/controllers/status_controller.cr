module Dorsum
  module Web
    module Controllers
      class StatusController
        def show(context)
          context.response.status = HTTP::Status::OK
          context.response.close
        end
      end
    end
  end
end
