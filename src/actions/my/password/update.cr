class My::Password::Update < BrowserAction
  include Sift::DontEnforceAuthorization

  post "/my/password" do
    ChangePassword.update(current_user, params) do |operation, _|
      if operation.saved?
        flash.keep
        flash.success = "Password changed."
        redirect to: My::Account::Show
      else
        flash.failure = "Colud not save."
        html ShowPage, user: current_user, save: operation
      end
    end
  end
end
