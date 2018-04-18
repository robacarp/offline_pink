require "jasper_helpers"
require "./application/url_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  include PinkAuthorization
  include UrlHelpers

  LAYOUT = "application.slang"

  def initialize(context)
    super
    @_current_user = User.guest_user
  end

  def logged_in?
    !current_user.id.nil?
  end

  def activated_user?
    logged_in? && current_user.activated?
  end

  macro require_activated_user
    before_action do
      all do
        unless activated_user?
          redirect_to "/"
        end
      end
    end
  end

  def current_user : User
    unless @_current_user_loaded
      @_current_user_loaded = true
      @_current_user = User.find(session[:user_id]) || @_current_user
    end

    @_current_user
  end

  def params_hash
    params.raw_params.to_h
  end

  private def login_user(user : User)
    session[:user_id] = user.id
  end

  private def logout
    session.destroy
  end

  private def redirect_to_domains
    redirect_to domains_path
  end

  private def redirect_to_domain(domain_id : Int64?) : Nil
    if domain_id
      redirect_to "/domain/#{domain_id}"
    else
      redirect_to_domains
    end
  end
end
