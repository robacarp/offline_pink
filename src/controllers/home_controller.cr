class HomeController < ApplicationController
  def index
    if current_user.guest?
      render "guest_index.slang"
    elsif ! current_user.is? :active
      render "deactivated_index.slang"
    else
      redirect_to domains_path
    end
  end
end
