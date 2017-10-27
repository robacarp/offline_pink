require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.slang"

  def initialize(something)
    @_current_user = User.new
  end

  def logged_in?
    ! current_user.id.nil?
  end

  def current_user : User
    # session.destroy

    # unless @_current_user_loaded
    #   @_current_user_loaded = true
    #   @_current_user = User.find(session[:user_id]) || @_current_user
    # end

    @_current_user
  end

  private def login_user(user : User)
    session[:user_id] = user.id
  end

  private def logout
    session.destroy
  end
end
