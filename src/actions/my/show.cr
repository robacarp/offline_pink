class Me::Show < BrowserAction
  get "/my/account" do
    render ShowPage, form: AccountForm.new(current_user)
  end
end
