abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery
  accepted_formats [:html, :json], default: :html

  include Authentic::ActionHelpers(User)
  include Auth::TestBackdoor
  include Auth::RequireSignIn
  include PolymorphicOwnership

  include AuthorizedLookup
  include AuthorizedScope

  expose current_user

  # This method tells Authentic how to find the current user
  private def find_current_user(id) : User?
    UserQuery.new.id(id).first?
  end

  def authorize(object, with policy, to action : Symbol = :read)
    policy.new(current_user, object).authorize(action)
  end

  def scoped_query(scope, with query)
    scope.new(current_user, query).scoped_query
  end
end
