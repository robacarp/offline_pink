module Foundation::ActionHelpers::SignIn(UserModel, UserQuery)
  USER_SESSION_KEY = "user_id"
  ADMIN_SESSION_KEY = "user_id"

  def sign_in(authenticatable : UserModel) : Void
    session.set(USER_SESSION_KEY, authenticatable.id.to_s)
  end

  def sign_out : Void
    session.clear
  end

  def current_user : UserModel
    current_user?
  end

  # Inspired by Authentic
  def current_user? : UserModel?
    if id = session.get?(USER_SESSION_KEY)
      current_user_memo(id)
    end
  end

  @users : Hash(String, UserModel?)?
  def current_user_memo(id) : UserModel?
    @users ||= Hash(String, UserModel?).new { |hash, key| hash[key] = query_for_user(id) }
    @users.try { |users| users[id] }
  end

  def query_for_user(user_id) : UserModel
    UserQuery.new.find user_id
  end

  def is_admin?(user : UserModel) : Bool
    user.is_admin?
  end
end
