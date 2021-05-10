module Foundation::ActionHelpers::OriginalRequestPreserver(UserModel)
  def redirect_to_originally_requested_path(fallback : Lucky::Action.class | Lucky::RouteHelper) : Lucky::Response
    return_to = session.get?(:return_to)
    session.delete(:return_to)
    redirect to: return_to || fallback
  end
end
