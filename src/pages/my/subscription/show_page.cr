class My::Subscription::ShowPage < AuthLayout
  def content
    small_frame do
      header_and_links do
        h1 "Enhanced Monitoring"
      end

      mount Shared::AlertBox do
        para "You are currently subscribed to the basic plan."
      end

      table do
        thead do
          tr do
            th ""
            th "Basic Plan (Free)"
            th "Enhanced Plan (#{OfflinePink::SUBSCRIPTION_PRICE})"
          end
        end

        tr do
          th "Data Retention"
          td "90 days"
          td "1 Year"
        end

        tr do
          th "Monitored Domains"
          td "1"
          td "3"
        end

        tr do
          th "Monitors per Domain"
          td "3"
          td "15"
        end

        tr do
          th "Data Export"
          td "CSV"
          td "CSV"
        end

        tr do
          th "Notifications"
          td "Email"
          td "Pushover, Slack"
        end
      end

      centered do
        themed_form My::Subscription::Create do
          submit "Subscribe to Enhanced Monitoring"
        end
      end
    end
  end
end
