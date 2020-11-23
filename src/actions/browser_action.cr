abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery
  accepted_formats [:html, :json], default: :html

  include Authentic::ActionHelpers(User)
  include Auth::TestBackdoor
  include Auth::RequireSignIn
  include PolymorphicOwnership

  include Sift::AuthorizingAction
  expose current_user

  # This method tells Authentic how to find the current user
  private def find_current_user(id) : User?
    UserQuery.new.id(id).first?
  end

end
