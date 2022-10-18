class My::Subscription::Finish < BrowserAction
  param checkout_session_id : String

  get "/my/subscription/finished" do
    flash.info = "Your subscription has been processed and enhanced monitoring is now active."
    redirect to: My::Subscription::Show
  end
end
