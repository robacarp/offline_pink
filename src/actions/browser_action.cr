abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery
  accepted_formats [:html, :json], default: :html

  include Foundation::ActionHelpers::Authentication(User, UserQuery)
  include PolymorphicOwnership
  include Pundit::ActionHelpers(User)
  include Featurette::ActionHelpers

  expose current_user

  private def query_for_user(user_id) : User?
    UserQuery.new
      .preload_enabled_features
      .preload_features
      .id(user_id).first?
  end
end
