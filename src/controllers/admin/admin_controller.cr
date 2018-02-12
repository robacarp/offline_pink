class Admin::Controller < ApplicationController
  LAYOUT = "admin.slang"

  def admin?
    logged_in? && current_user.admin?
  end

  before_action do
    all do
      unless admin?
        redirect_to "/"
      end
    end
  end
end
