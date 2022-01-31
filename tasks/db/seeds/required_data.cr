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

    FeatureFactory.create do |feature|
      feature.name "domain_monitoring"
    end

    FeatureFactory.create do |feature|
      feature.name "admin"
    end

    FeatureFactory.create do |feature|
      feature.name "pushover"
    end

    puts "Done adding required data"
  end
end
