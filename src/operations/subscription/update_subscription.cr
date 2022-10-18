class UpdateSubscription < Avram::Operation
  include StripeUserLookup

  needs stripe_subscription : Stripe::Subscription

  def run
    cancel_date = stripe_subscription.cancel_at 

    if stripe_subscription.cancel_at_period_end
      cancel_date = stripe_subscription.current_period_end
    end

    subscription = SubscriptionQuery.new
      # .stripe_id(stripe_id)
      .user_id(user.id)
      .first
  end
end
