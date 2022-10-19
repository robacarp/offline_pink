class SubscriptionPaymentSucceeded < Avram::Operation
  include StripeUserLookup

  def run
    subscription = user.subscription
    return unless subscription
    stripe_subscription = Stripe::Subscription.retrieve subscription.stripe_id
    UpdateSubscription.run! stripe_customer_id: stripe_customer_id, stripe_subscription: stripe_subscription
  end
end
