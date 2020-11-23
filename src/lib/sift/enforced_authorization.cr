module Sift
  # Include into an action when no enforcement is required
  module DontEnforceAuthorization
    macro included
      skip ensure_authorized
    end
  end

  # Included by default in AuthorizingAction
  module EnforcedAuthorization
    macro included
      after ensure_authorized
    end

    @_authorization_enforced = false
    @_skipping_authorization_enforcement = false

    def dont_enforce_authorization!
      @_skipping_authorization_enforcement = true
    end

    def _authorized!
      @authorization_enforced = true
    end

    def ensure_authorized
      unless @_skipping_authorization_enforcement || @authorization_enforced
        raise NotAuthorized.new("No authorization performed")
      end

      continue
    end
  end
end
