abstract class GuestLayout < BaseLayout
  needs current_user : User?
  needs admin_user : User?
end
