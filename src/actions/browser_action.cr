abstract class BrowserAction < Lucky::Action
  include Lucky::SecureHeaders::DisableFLoC
  include Lucky::ProtectFromForgery
  accepted_formats [:html, :json], default: :html

  include Foundation::ActionHelpers::Authentication(User, UserQuery)
  include PolymorphicOwnership
  include Pundit::ActionHelpers(User)
  include Featurette::ActionHelpers

  private def query_for_user(user_id) : User?
    UserQuery.new
      .preload_enabled_features
      .preload_features
      .id(user_id).first?
  end

  private def is_admin?(user : User) : Bool
    features = UserQuery.preload_features(user).features
    features.map(&.name).includes? "admin"
  end
end
