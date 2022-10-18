class DeleteSubscription < Avram::Operation
  include StripeUserLookup

  needs stripe_id : String

  def run
    subscription = SubscriptionQuery.new
      .stripe_id(stripe_id)
      .user_id(user.id)
      .first?

    if subscription_ = subscription
      Subscription::DeleteOperation.delete! subscription_
    else
      Log.warn { "No subscription found" }
    end
  end
end
