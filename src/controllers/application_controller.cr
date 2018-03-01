require "jasper_helpers"
require "./application_controller/pundit_authorization"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  include PunditAuthorization

  LAYOUT = "application.slang"

  def initialize(context)
    super
    @_current_user = User.guest_user
  end

  def logged_in?
    !current_user.id.nil?
  end

  def current_user : User
    unless @_current_user_loaded
      @_current_user_loaded = true
      @_current_user = User.find(session[:user_id]) || @_current_user
    end

    @_current_user
  end

  private def login_user(user : User)
    session[:user_id] = user.id
  end

  private def logout
    session.destroy
  end

  private def redirect_to_domains
    redirect_to "/my/domains"
  end

  private def redirect_to_domain(domain_id : Int64?) : Nil
    if domain_id
      redirect_to "/domain/#{domain_id}"
    else
      redirect_to_domains
    end
  end
end
