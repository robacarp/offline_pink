class My::Account::Update < BrowserAction
  include Sift::DontEnforceAuthorization

  post "/my/account" do
    SaveUser.update(current_user, params) do |operation, updated_user|
      if operation.saved?
        flash.keep
        flash.success = "Updated!"
        redirect to: My::Account::Show
      else
        flash.failure = "Could not save"
        html ShowPage, user: current_user, save: operation
      end
    end
  end
end
