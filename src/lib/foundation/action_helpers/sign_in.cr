module Foundation::ActionHelpers::SignIn(UserModel, UserQuery)
  USER_SESSION_KEY = "user_id"
  ADMIN_SESSION_KEY = "admin_user_id"

  def admin_takeover(user : UserModel)
    if session.get?(ADMIN_SESSION_KEY)
      session.set(USER_SESSION_KEY, user.id.to_s)
    end
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
    admin_user?.tap do |u|
      puts "Admin User: #{u}"
    end
  end

  def admin_user? : UserModel?
    if id = session.get?(ADMIN_SESSION_KEY)
      current_user_memo(id)
    end
  end

  # Check to see if there's a current user.
  def current_user? : UserModel?
    if id = session.get?(USER_SESSION_KEY)
      current_user_memo(id)
    end
  end

  # Memoized user lookup.
  @users : Hash(String, UserModel?)?
  def current_user_memo(id) : UserModel?
    @users ||= Hash(String, UserModel?).new { |hash, key| hash[key] = query_for_user(id) }
    @users.try { |users| users[id] }
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
