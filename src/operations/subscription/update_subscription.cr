class UpdateSubscription < Avram::Operation
  include StripeUserLookup

  needs stripe_subscription : Stripe::Subscription

  def run
    subscription = user.subscription
    raise "User#{user.id} does not have a subscription." unless subscription

    expires_at = stripe_subscription.current_period_end
    expires_at += 2.days

    if cancel_date = stripe_subscription.cancel_at 
      expires_at = cancel_date
    end

    case stripe_subscription.status
    when Stripe::Subscription::Status::Incomplete,
         Stripe::Subscription::Status::IncompleteExpired,
         Stripe::Subscription::Status::PastDue,
         Stripe::Subscription::Status::Canceled,
         Stripe::Subscription::Status::Unpaid

      Log.info { "Subscription status is #{stripe_subscription.status}. Cancelling subscription." }

      expires_at = Time.utc
    end

    Log.info { "Updating subscription #{subscription.id} to expire at #{expires_at}" }

    Subscription::SaveOperation.update! subscription, expires_at: expires_at
  end
end
