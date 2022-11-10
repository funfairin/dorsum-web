module Dorsum
  module Web
    module Controllers
      class PagesController
        def index(context)
          context.response.status = HTTP::Status::OK
          context.response.headers["Content-Type"] = "text/html; charset=utf-8"
          context.response.headers["X-Permitted-Cross-Domain-Policies"] = "none"
          context.response.headers["Referrer-Policy"] = "strict-origin-when-cross-origin"
          context.response.headers["Content-Security-Policy"] = "default-src 'self'; object-src 'none'; script-src 'self'"
          Dorsum::Web::Views::Layouts::Application.new("Dorsum") do
            Dorsum::Web::Views::Pages::Index.new.to_s(context.response)
          end.to_s(context.response)
        end
      end
    end
  end
end
