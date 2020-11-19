require "../spec/support/boxes/**"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::CreateRequiredSeeds` if you need to create data *required* for your
# app to work.
class Db::CreateSampleSeeds < LuckyCli::Task
  summary "Add sample database records helpful for development"

  def call
    users = [
      UserBox.create,
      UserBox.create
    ]

    org = OrganizationBox.create


    users.each do |user|
      MembershipBox.create do |membership|
        membership.admin false
        membership.user_id user.id
        membership.organization_id org.id

        membership
      end
    end

    # Using a LuckyRecord::Box:
    #
    # Use the defaults, but override just the email
    # UserBox.create &.email("me@example.com")

    # Using a form:
    #
    # UserForm.create!(email: "me@example.com", name: "Jane")
    puts "Done adding sample data"
  end
end
