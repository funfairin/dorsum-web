module Dorsum
  module Web
    # Keeps the details of how the CLI tool was called.
    class Context
      property errors : Array(String)
      property command : String
      property? run
      property? verbose

      def initialize
        @errors = [] of String
        @command = "run"
        @run = true
        @verbose = false
      end
    end
  end
end
