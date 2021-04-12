require "../../../spec/support/factories/**"

# Add seeds here that are *required* for your app to work.
# For example, you might need at least one admin user or you might need at least
# one category for your blog posts for the app to work.
#
# Use `Db::Seed::SampleData` if your only want to add sample data helpful for
# development.
class Db::Seed::RequiredData < LuckyTask::Task
  summary "Add database records required for the app to work"

  def call
    RegionFactory.create do |region|
      region.name("Region 1")
    end
    # Using a LuckyRecord::Box:
    #
    # Use the defaults, but override just the email
    # UserBox.create &.email("me@example.com")

    # Using a form:
    #
    # UserForm.create!(email: "me@example.com", name: "Jane")
    #
    # You likely want to be able to run this file more than once. To do that,
    # only create the record if it doesn't exist yet:
    #
    # unless UserQuery.new.email("me@example.com").first?
    #  # create the user
    # end
    puts "Done adding required data"
  end
end
