class Admin::Controller < ApplicationController
  LAYOUT = "admin.slang"

  def admin?
    logged_in? && current_user.admin?
  end
end
