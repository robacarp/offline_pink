module Foundation::LayoutHelpers::Authentication
  abstract def current_user
  abstract def admin_user

  def sudo_active? : Bool
    return false unless admin = admin_user
    return false unless viewer = current_user

    puts "user: #{viewer.id}"
    puts "admin: #{admin.id}"
    viewer.id != admin.id
  end
end
