abstract class AuthLayout < BaseLayout
  include Foundation::LayoutHelpers::Authenticated
  include Featurette::LayoutHelpers

  needs organizations : OrganizationQuery
  needs possible_owners : Array(NamedValue)
end
