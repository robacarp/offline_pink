abstract class AuthLayout < BaseLayout
  include Foundation::LayoutHelpers::Authenticated
  include Featurette::LayoutHelpers(Feature)

  needs organizations : OrganizationQuery
  needs possible_owners : Array(NamedValue)
end
