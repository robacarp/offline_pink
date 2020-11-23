module Sift
  class NotAuthorized < Exception
    def initialize(@message = "Not Authorized")
    end
  end
end
