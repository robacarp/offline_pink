class My::Account::Update < BrowserAction
  post "/my/account" do
    SaveUser.update(current_user, params) do |operation, _updated_user|
      if operation.saved?
        flash.keep
        flash.success = "Updated"
        redirect to: My::Account::Show
      else
        flash.failure = "Could not save"
        html ShowPage, user: current_user, save: operation
      end
    end
  end
end
