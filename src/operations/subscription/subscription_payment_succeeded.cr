class SubscriptionPaymentSucceeded < Avram::Operation
  include StripeUserLookup

  def run
    subscription = SubscriptionQuery.new
      # .stripe_id(stripe_id)
      .user_id(user.id)
      .first

    # TODO calculate how long the subscription should renew based on the invoice?
    Subscription::SaveOperation.update!(
      subscription,
      user_id: user.id,
      expires_at: Time.utc + 1.month
    )
  end
end
