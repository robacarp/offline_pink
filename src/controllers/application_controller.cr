require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
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

  macro authorize_with(policy_class, protected_class)
    @_authorized = false
    @_authorization_skipped = false
    @_scoped = false

    private def policy
      {{ policy_class }}
    end

    private def current_user_object_policy(object)
      {{ policy_class }}.new current_user, object
    end

    private def current_user_policy
      {{ policy_class }}.new current_user
    end

    private def policy_scope
      @_scoped = true
      {{ policy_class }}::Scope.new(current_user).resolve
    end

    private def authorize(object)
      unless object.is_a? {{ protected_class }}
        raise "Invalid Authorization"
      end

      policy = current_user_object_policy object
      result = policy.can_user_act? action_name

      unless result
        raise "Not Authorized. User(#{current_user.id}) cannot perform #{action_name} on #{object.class}##{object.id}"
      end

      @_authorized = true
    end

    private def authorize(object, *, with object_policy : ApplicationPolicy.class, for action : Symbol)
      unless object.class == object_policy.policy_type
        raise "Invalid Authorization"
      end

      policy = object_policy.new current_user, object

      unless policy.can_user_act? action
        raise "Not Authorized"
      end
    end

    def skip_authorization
      @_authorization_skipped = true
    end

    after_action do
      all {
        if ! @_authorization_skipped && ! redirecting && ! @_authorized && ! @_scoped
          raise "Authorization for action not triggered: #{controller_name}.#{action_name}"
        end
      }
    end
  end

  macro require_logged_in
    before_action do
      all do
        unless logged_in?
          redirect_to "/"
        end
      end
    end
  end
end
