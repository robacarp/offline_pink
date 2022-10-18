class My::Subscription::Create < BrowserAction
  # Find or create a stripe customer id for the user
  def stripe_customer_id
    if stripe_id = current_user.stripe_id
      # The user already has a Stripe customer ID
      stripe_id
    else
      # No customer is found, attach the customer_id to the current user
      customer = Stripe::Customer.create email: current_user.email
      User::ConnectToStripe.update! current_user, stripe_id: customer.id
      customer.id
    end
  end

  def create_session(second_try = false) : Stripe::Checkout::Session
    success_url = My::Subscription::Finish.url_without_query_params
    success_url += "?checkout_session_id={CHECKOUT_SESSION_ID}"

    Stripe::Checkout::Session.create(
      mode: "subscription",
      line_items: [{
        quantity: 1,
        price: "price_1LuIy1JKARJsQAQHvcJg73YI"
      }],
      customer: stripe_customer_id,
      success_url: success_url,
      cancel_url: My::Subscription::Show.url,
      payment_method_types: ["card"]
    )
  rescue e : Stripe::Error
    raise e unless e.message =~ /No such customer/
    Log.warn { "The customer was deleted from Stripe, but not from the database" }

    if second_try
      Log.error { "The customer was detached from the User but still couldn't be found in Stripe" }
      raise e
    end

    User::ConnectToStripe.update! current_user, stripe_id: nil
    reload_current_user
    create_session(second_try: true)
  end

  post "/my/subscription" do
    if redirect_url = create_session.url
      redirect redirect_url, 303
    else
      raise "Error creating Stripe Checkout Session"
    end
  end
end
