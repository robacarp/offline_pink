class ApplicationPolicy
  macro policy_for(object_class, *methods, **method_map)
    getter current_user : User
    getter object : {{ object_class }}

    def initialize(@current_user : User, @object : {{ object_class }})
    end

    def self.policy_type
      {{ object_class }}
    end

    def can_user_act?(action)
      case action
        {% for method in methods %}
          when {{ method }}
            {{ method.id }}?
        {% end %}

        {% for action, method in method_map %}
          when :{{ action }}
            {{ method.id }}?
        {% end %}
      else
        raise "Incomplete Policy: #{ {{ @type }} } does not declare and publish policy for the #{action} method."
      end
    end
  end

  macro default_policy_for(object_class)
    policy_for({{ object_class }},
      :show,
      new: :create,
      create: :create,
      edit: :edit,
      update: :update
    )
  end

  macro resolve
    class Scope
      getter current_user : User

      def initialize(@current_user : User)
      end

      def resolve
        {{ yield }}
      end
    end
  end

  def logged_in?
    ! current_user.id.nil?
  end

  def user_is_owner?
    object.user_id == current_user.id
  end

end
