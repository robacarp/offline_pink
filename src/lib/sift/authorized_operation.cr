module Sift
  module AuthorizedOperation
    @_authorized = false

    macro included
      after_save validate_sift_authorized
    end

    def skip_sift_authorization!
      @_authorized = true
    end

    def validate_sift_authorized(_object)
      unless @_authorized
        raise Sift::NotAuthorized.new("operation was not authorized")
      end
    end

    def sift_authorized!
      @_authorized = true
    end
  end
end
