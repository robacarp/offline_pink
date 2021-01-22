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
  @users : Hash(String, User?)?
  private def find_current_user(id) : User?
    @users ||= Hash(String, User?).new do |hash, key|
      hash[key] = UserQuery.new.id(key).first?
    end
    @users.try { |users| users[id] }
  end

end
