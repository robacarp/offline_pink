module PinkAuthorization
  macro included
    macro authorize_with(policy_class, protected_class)
      @_authorized = false
      @_authorization_skipped = false
      @_scoped = false

      private def policy
        \{{ policy_class }}
      end

      private def current_user_object_policy(object)
        \{{ policy_class }}.new current_user, object
      end

      private def current_user_policy
        \{{ policy_class }}.new current_user
      end

      private def policy_scope
        @_scoped = true
        \{{ policy_class }}::Scope.new(current_user).resolve
      end

      private def authorize(object, user : User = current_user) : Nil
        unless object.is_a? \{{ protected_class }}
          raise AccessDenied.new("Invalid Authorization")
        end

        policy = current_user_object_policy object
        result = policy.can_user_act? action_name

        unless result
          raise AccessDenied.new("Not Authorized. User(#{current_user.id}) cannot perform #{action_name} on #{object.class}(#{object.id})")
        end

        @_authorized = true
      end

      private def authorize(object, *, with object_policy : ApplicationPolicy.class, for action : Symbol, user : User = current_user) : Nil
        unless object.class == object_policy.policy_type
          raise AccessDenied.new("Invalid Authorization")
        end

        policy = object_policy.new user, object

        unless policy.can_user_act? action
          raise AccessDenied.new("Not Authorized. User(#{current_user.id}) cannot perform #{action_name} on #{object.class}(#{object.id})")
        end

        @_authorized = true
      end

      def skip_authorization
        @_authorization_skipped = true
      end

      after_action do
        all {
          if ! @_authorization_skipped && ! redirecting && ! @_authorized && ! @_scoped
            raise AccessDenied.new("Authorization for action not triggered: #{controller_name}.#{action_name}")
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
end
