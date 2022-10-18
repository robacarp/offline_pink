class CreateSubscription < Avram::Operation
  include StripeUserLookup

  needs stripe_id : String

  def run
    Subscription::SaveOperation.create!(
      user_id: user.id,
      stripe_id: stripe_id
    )
  end
end
