module Foundation::ActionHelpers::EnsureAdminPresent
  macro included
    before require_admin_present
  end

  private def require_admin_present
    if admin_user?
      continue
    else
      remember_requested_path
      flash.info = "Please sign in first"
      redirect to: SignIns::New
    end
  end
end
