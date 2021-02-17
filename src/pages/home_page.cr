class HomePage < GuestLayout
  def content
    shrink_to_fit do
      para "Offline.pink domain and service availability monitoring."

      ul do
        li do
          strong "No data warehousing."
          br
          text "We don't want to monitor the entire internet and inspect it to see what's happening around the globe. We want to enable you to monitor your own services."
        end

        li do
          strong "No Soft Delete."
          br
          text "If the monitor is no longer necessary, neither is the record of it having been monitored."
        end

        li do
          strong "Monitoring should be cheap."
          br
          text "Real time monitoring is easy, reliable notifications aren't."
        end
      end

      hr
    end
  end
end
