class My::Subscription::SubscribedPage < AuthLayout
  needs subscription : ::Subscription

  def content
    small_frame do
      header_and_links do
        h1 "Enhanced Monitoring"
      end

      subscription_status

      centered do
        themed_form My::Subscription::Update do
          submit "Manage Subscription"
        end
      end
    end
  end

  def subscription_status
    if subscription.active?
      mount Shared::AlertBox do
        para "You are currently subscribed to the Enhanced Monitoring plan. Thank you for your support."
      end
    else
      mount Shared::AlertBox, severity: "failure" do
        para "Your subscription to Enhanced Montoring has expired. If you'd like to reactivate Enhanced Monitoring, you can renew at any time."
      end
    end
  end
end
