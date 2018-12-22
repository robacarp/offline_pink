class Me::Update < BrowserAction
  post "/my/account" do
    AccountForm.update(current_user, params) do |form, updated_user|
      if form.saved?
        flash.success = "Updated!"
        redirect to: Me::Show
      else
        flash.failure = "Could not save"
        render ShowPage, form: form
      end
    end
  end
end
