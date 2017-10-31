require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.slang"

  getter current_action : Symbol
  def initialize(context)
    super
    @current_action = context.route.payload.action
    @_current_user = User.guest_user
  end

  def logged_in?
    ! current_user.id.nil?
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

  macro authorize_with(policy_class, protected_class)
    @_authorized = false
    @_scoped = false

    def policy
      {{ policy_class }}
    end

    def current_user_object_policy(object)
      {{ policy_class }}.new current_user, object
    end

    def current_user_policy
      {{ policy_class }}.new current_user
    end

    def policy_scope
      @_scoped = true
      {{ policy_class }}::Scope.new(current_user).resolve
    end

    def authorize(object)
      unless object.is_a? {{ protected_class }}
        raise "Invalid Authorization"
      end

      @_authorized = true

      policy = current_user_object_policy object
      result = policy.can_user_act? current_action

      unless result
        raise "Not Authorized"
      end
    end

    after_action do
      all {
        if ! @_authorized && ! @_scoped
          raise "Authorization for action not triggered"
        end
      }
    end
  end
end
