class Me::Update < BrowserAction
  post "/my/account" do
    SaveUser.update(current_user, params) do |operation, updated_user|
      if operation.saved?
        flash.success = "Updated!"
        redirect to: Me::Show
      else
        flash.failure = "Could not save"
        html ShowPage, user: current_user
      end
    end
  end
end
