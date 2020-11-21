require "faker"
require "../../../spec/support/boxes/**"

# Add sample data helpful for development, e.g. (fake users, blog posts, etc.)
#
# Use `Db::Seed::RequiredData` if you need to create data *required* for your
# app to work.

class SimpleSaveDomain < Domain::SaveOperation
  permit_columns name, user_id, organization_id
end

class Db::Seed::SampleData < LuckyCli::Task
  summary "Add sample database records helpful for development"

  def call
    dev_user_email = "test@example.com"
    dev_user = UserQuery.new.email(dev_user_email).first? || UserBox.create do |user|
      user.email dev_user_email
    end

    users = [
      dev_user,
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

    SimpleSaveDomain.create!(
      user_id: users.first.id,
      name: Faker::Internet.domain_name
    )

    SimpleSaveDomain.create!(
      organization_id: org.id,
      name: Faker::Internet.domain_name
    )

    puts "Done adding sample data"
  end
end
