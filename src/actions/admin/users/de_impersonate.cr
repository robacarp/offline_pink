class Admin::Users::EndImpersonation < AdminAction
  allow_feature_bypass admin
  include Foundation::ActionHelpers::EnsureAdminPresent

  delete "/users/assume" do
    flash.success = "No longer impersonating #{current_user.email}"
    end_admin_takeover
    redirect to: Home::Index
  end
end
