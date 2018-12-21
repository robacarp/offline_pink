module Auth::SessionManagement
  SESSION_KEY = "user_id"

  def create_session(for user : User)
    session.set SESSION_KEY, user.id.to_s
  end

  def destroy_session
    session.clear
  end

  def current_user
    current_user?
  end

  @user : User?

  def current_user?
    @user ||= begin
      if id = session.get? SESSION_KEY
        UserQuery.find id
      end
    end
  end
end
