abstract class GuestLayout < Layout
  needs current_user : User?
end
