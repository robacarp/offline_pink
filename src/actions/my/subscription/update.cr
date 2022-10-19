class My::Subscription::Update < BrowserAction
  post "/my/subscription/review" do

    stripe_id = current_user.stripe_id

    return redirect My::Subscription::Show.url if stripe_id.nil?

    session = Stripe::BillingPortal::Session.create(
      customer: stripe_id,
      return_url: My::Subscription::Show.url
    )

    if redirect_url = session.url
      redirect redirect_url, 303
    else
      raise "could not fetch redirect_url"
    end
  end
end
