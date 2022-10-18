require "stripe"

# accepted_formats [:xml] probably represents a bug in lucky, because the actual request is Accept: */*; q=0.5, application/xml
# The Stripe lib must be referenced as ::Stripe because the namespace of this webhook collides with the Stripe namespace and the compiler assumes the local namespace is correct.

class Webhook::Stripe < ApiAction
  accepted_formats [:xml]

  @_stripe_event : ::Stripe::Event?

  def stripe_event : ::Stripe::Event
    if _stripe_event = @_stripe_event
      return _stripe_event 
    end

    webhook_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET")
    signature_header = request.headers["Stripe-Signature"]

    @_stripe_event = event = ::Stripe::Webhook.construct_event(
      payload: request.body.not_nil!.gets_to_end,
      sig_header: signature_header,
      secret: webhook_secret
    )
  rescue e
    Log.error(exception: e) { "Stripe webhook failed to parse JSON:" + request.body.not_nil!.gets_to_end }
    raise e
  end

  def stripe_customer_id(from event_data_object) : String
    case candidate = event_data_object.customer
    when String
      candidate
    when ::Stripe::Customer
      candidate.id
    else
      raise "No customer provided on stripe subscription event"
    end
  end

  post "/webhook/stripe" do
    event = stripe_event

    Log.info { "Stripe webhook received: #{event.type}" }

    # todo there are still some holes in this logic:
    # - Stripe seems to indicate that I should keep track of the expiration date of a subscription
    #   - But the expiration date isn't always present.
    #   - https://stripe.com/docs/billing/subscriptions/webhooks#active-subscriptions
    #   - "appropriate date in the future" - what is that date?
    # - Other parts of the documentation indicate that it is sufficient to watch for the status
    #   of a subscription to change to inactive.
    #   - This flag is always present but I'm not doing anything with it because of the above.
    #   - https://stripe.com/docs/billing/subscriptions/webhooks#state-changes
    # - Some of the docs indicate that watching for payment failures is necessary too.
    #   - I'm not doing this yet.
    # - Testing this stuff isn't possible right now 
    #   - https://github.com/confact/stripe.cr/issues/53
    case event.type
    when "customer.subscription.created"
      subscription = event.data.object.as ::Stripe::Subscription
      customer_id = stripe_customer_id from: subscription
      Log.info { "Stripe subscription: #{subscription.id}" }
      Log.info { "Customer ID: #{customer_id}" }

      CreateSubscription.run!  stripe_customer_id: customer_id, stripe_id: subscription.id
    when "customer.subscription.updated"
      subscription = event.data.object.as ::Stripe::Subscription
      customer_id = stripe_customer_id from: subscription
      Log.info { "Stripe subscription: #{subscription.id}" }
      Log.info { "Customer ID: #{customer_id}" }

      # TODO: when does this get called?
      # CreateSubscription.update!(stripe_id: request.data.object.id)
    when "customer.subscription.deleted"
      subscription = event.data.object.as ::Stripe::Subscription
      customer_id = stripe_customer_id from: subscription
      Log.info { "Stripe subscription: #{subscription.id}" }
      Log.info { "Customer ID: #{customer_id}" }

      DeleteSubscription.run! stripe_customer_id: customer_id, stripe_id: subscription.id
    when "payment_intent.succeeded"
      payment_intent = event.data.object.as ::Stripe::PaymentIntent
      customer_id = stripe_customer_id from: payment_intent

      Log.info { "Payment intent: #{payment_intent.id}" }
      Log.info { "Customer ID: #{customer_id}" }

      SubscriptionPaymentSucceeded.run! stripe_customer_id: customer_id
    else
      raise "unhandled Stripe webhook event type: #{event.type}"
    end

    raw_json "{}", 200
  end
end
