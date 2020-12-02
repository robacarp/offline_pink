class My::Password::ShowPage < AuthLayout
  needs user : User
  needs save : ChangePassword

  def content
    small_frame do
      h1 "Change Password"
      hr

      shrink_to_fit do
        form_for My::Password::Update do
          mount Shared::Field, attribute: save.old_password, &.password_input(placeholder: "*************")
          mount Shared::Field, attribute: save.password, &.password_input(placeholder: "*************")
          mount Shared::Field, attribute: save.password_confirmation, &.password_input(placeholder: "*************")

          shrink_to_fit do
            submit "Change Password"
          end
        end
      end
    end
  end
end
