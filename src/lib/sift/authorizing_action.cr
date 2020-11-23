module Sift
  # To be included in a superclass of Lucky::Actions, eg:
  #
  # abstract class BrowserAction < Lucky::Action
  #  include Sift::AuthorizingAction
  # end
  module AuthorizingAction
    macro included
      include Sift::AuthorizedLookup
      include Sift::AuthorizedScope
      include Sift::EnforcedAuthorization
    end

    def authorize(object, with policy, to action : Symbol = :read)
      _authorized!
      policy.new(current_user, object).authorize(action)
    end

    def scoped_query(scope, with query)
      _authorized!
      scope.new(current_user, query).scoped_query
    end
  end
end
