module Auth::SessionEnforcement
  macro require_logged_in!
    before ensure_logged_in

    private def current_user : User
      current_user?.not_nil!
    end
  end

  macro dont_require_logged_in!
    def ensure_logged_in
      continue
    end

    private def current_user : User?
      current_user?
    end
  end

  macro redirect_if_signed_in!
    dont_require_logged_in!
    before redirect_if_signed_in

    private def current_user
    end
  end

  private def ensure_logged_in
    if current_user?
      continue
    else
      Authentic.remember_requested_path(self)
      flash.info = "Please sign in first"
      redirect to: Session::New
    end
  end

  private def redirect_if_signed_in
    if current_user?
      flash.success = "You are already signed in"
      redirect to: Home::Index
    else
      continue
    end
  end

  abstract def current_user
end
