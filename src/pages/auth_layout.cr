abstract class AuthLayout < BaseLayout
  needs current_user : User
  needs admin_user : User?

  needs organizations : OrganizationQuery
  needs possible_owners : Array(NamedValue)

  include Featurette::LayoutHelpers(Feature)
end
