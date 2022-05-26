class My::Account::ShowPage < AuthLayout
  needs user : User
  needs save : SaveUser

  def content
    small_frame do
      header_and_links do
        h1 "Your Account"

        div do
          link "Sign out", to: SignIns::Delete
          middot_sep
          link "Change your password", to: My::Password::Change
        end
      end

      themed_form My::Account::Update do
        mount Shared::Field, attribute: save.email, &.text_input
        pushover_settings if feature_enabled?(:pushover)
        submit "Save"
      end

      if (memberships = user.memberships!).any?
        header_and_links do
          h1 "Organization Membership"
          link "Create a new Organization", to: Organizations::New
        end

        table do
         memberships.each do |membership|
           organization_row membership
         end
        end
      end

    end
  end

  private def organization_row(membership)
    organization = membership.organization!

    tr do
      td do
        link organization.name, to: Organizations::Show.route(organization)
      end

      td do
        if membership.admin?
          text "Admin"
        end
      end
    end
  end

  private def pushover_settings
    div class: "mb-4" do
      div class: "flex mb-3" do
        label_for save.pushover_key, "Pushover Settings"

        nbsp

        classes = %w|text-sm mb-2|
        valid_text = ""

        if user.valid_pushover_settings == User::Validity.new(:valid)
          classes << "text-green-500"
          valid_text = "valid"
        elsif user.valid_pushover_settings == User::Validity.new(:invalid)
          classes << "text-red-500"
          valid_text = "invalid"
        elsif user.valid_pushover_settings == User::Validity.new(:unchecked)
          classes << "text-amber-500"
          valid_text = "unchecked"
        end

        span class: class_list(classes) do
          text valid_text
        end
      end

      shared_classes = %|text-gray-700 leading-tight py-2|

      text_input field: save.pushover_key,
        placeholder: "Pushover key",
        class: class_list("rounded-l pl-2", shared_classes)

      text_input field: save.pushover_device,
        placeholder: "(optional) Device",
        class: class_list("rounded-r pr-2", shared_classes)
      br

      if user.valid_pushover_settings == User::Validity.new(:valid)
        link "Send Test Notification", to: My::TestPushNotification
      end
    end
  end
end
