class Admin::Users::IndexPage < AuthLayout
  needs users : UserQuery

  def content
    small_frame do
      header_and_links "Users"

      table class: "mx-auto w-64 table-zebra table-borders" do
        tr do
          th "ID"
          th "Email Address"
          th "Signed Up At"
        end

        @users.each { |user| user_row for: user }
      end
    end
  end

  def user_row(for user : User)
    tr do
      td user.id

      td do
        link user.email, to: Admin::Users::Show.with(user)
      end

      td user.created_at.to_rfc3339
    end
  end
end
