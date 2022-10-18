class My::Subscription::Show < BrowserAction
  get "/my/subscription" do
    if subscription = current_user.subscription
      html SubscribedPage, subscription: subscription
    else
      html ShowPage
    end
  end
end
