module Amber::Controller
  module Helpers
    private class Redirector
      def redirect(controller)
        controller.redirecting = true
        previous_def
      end
    end
  end

  class Base
    property redirecting = false
  end
end
