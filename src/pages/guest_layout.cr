abstract class GuestLayout < BaseLayout
  needs current_user : User?
end
