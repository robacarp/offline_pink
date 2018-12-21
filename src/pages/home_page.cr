class HomePage < GuestLayout
  def content
    div ".row" do
      div ".col-md-6.offset-md-3" do
        para "Offline pink monitors domain and service availability and connectivity with a few simple principals:"

        ul do
          li do
            strong "No data warehousing."
            text "I don't want to monitor the entire internet and inspect it to see what's happening around the globe."
          end

          li do
            strong "No Soft Delete."
            text "If the monitor is no longer necessary, neither is the record of it having been monitored."
          end

          li do
            strong "Monitoring should be cheap."
            text "Real time monitoring is easy, reliable notifications aren't. But I don't think it has to be that way."
          end
        end

        hr

        h4 "Notifications"

        para <<-TEXT
          Service interruption notifications aren't being sent yet. This feature is under development.
        TEXT

        hr

        h4 "Membership"

        para <<-TEXT
          Offline.pink is in private alpha testing. Membershipara is freely available but the ability to
          monitor domains and services is limited to invited users.
        TEXT

        para <<-TEXT
          Invitations are available for a small number of users willing to provide feedback during the
          testing phases.
        TEXT

        hr

        h4 "Changelog"

        ul do
          li do
            para do
              em "2018-06-06"
            end

            para "User profiles are now editable."
          end

          li do
            para do
              em "2018-04-26"
            end

            para "Added invite functionality. New users must be invited or activated by an Admin."
          end

          li do
            para do
              em "2018-02-07"
            end

            para "Offline.pink is now minimally configured to send emails."
          end


          li do
            para do
              em "2018-01-17"
            end

            para "Monitoring begins"
          end
        end

      end
    end
  end
end
