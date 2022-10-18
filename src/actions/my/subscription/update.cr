class My::Subscription::Update < BrowserAction
  post "/my/subscription/review" do
    return_url = My::Subscription::Show.url

    stripe_id = current_user.stripe_id

    return redirect My::Subscription::Show.url if stripe_id.nil?

    # todo this doesnt seem to actually let a user edit or cancel
    session = Stripe::BillingPortal::Session.create(
      customer: stripe_id,
      return_url: return_url
    )

    if redirect_url = session.url
      redirect redirect_url, 303
    else
      raise "could not fetch redirect_url"
    end
  end
end
