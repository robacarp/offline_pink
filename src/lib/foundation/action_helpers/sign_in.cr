module Foundation::ActionHelpers::SignIn(UserModel, UserQuery)
  USER_SESSION_KEY = "user_id"
  ADMIN_SESSION_KEY = "admin_user_id"

  def admin_takeover(user : UserModel)
    if session.get?(ADMIN_SESSION_KEY)
      session.set(USER_SESSION_KEY, user.id.to_s)
    end
  end

  def end_admin_takeover
    session.set(USER_SESSION_KEY, session.get(ADMIN_SESSION_KEY))
  end

  def sign_in(user : UserModel) : Void
    session.set(USER_SESSION_KEY, user.id.to_s)

    if is_admin? user
      session.set(ADMIN_SESSION_KEY, user.id.to_s)
    end
  end

  def sign_out : Void
    session.clear
  end

  # Override when possible to drop the nil
  def current_user : UserModel?
    current_user?
  end

  # Override when possible to drop the nil
  def admin_user : UserModel?
    admin_user?
  end

  def admin_user? : UserModel?
    if id = session.get?(ADMIN_SESSION_KEY)
      user_lookup_table[id]
    end
  end

  # Check to see if there's a current user.
  def current_user? : UserModel?
    if id = session.get?(USER_SESSION_KEY)
      user_lookup_table[id]
    end
  end

  # Memoized user lookup table.
  @users : Hash(String, UserModel?)?
  private def user_lookup_table : Hash(String, UserModel?)
    @users ||= Hash(String, UserModel?).new do |cache, key|
      cache[key] = query_for_user(key)
    end
  end

  def reload_current_user
    user_lookup_table.delete current_user.id.to_s
  end

  # Look up a user in the database.
  # Overridable to provide preloads if needed.
  def query_for_user(user_id) : UserModel
    UserQuery.new.find user_id
  end

  # Determine if a given user is an admin.
  # Overridable to provide preloads if needed.
  def is_admin?(user : UserModel) : Bool
    user.is_admin?
  end
end
