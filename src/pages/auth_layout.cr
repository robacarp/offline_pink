abstract class AuthLayout < BaseLayout
  needs current_user : User
end
