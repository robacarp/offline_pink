class PinkAuthorization::Policy
  macro policy_for(object_class, *methods, **method_map)
    getter current_user : User

    def object? : {{ object_class }} | Nil
      @object
    end

    def object : {{ object_class }}
      if value = object?
        return value
      else
        raise "{{ object_class }} was Nil, unable to authorize"
      end
    end

    def initialize(@current_user : User, @object : {{ object_class }} | Nil)
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
      :show, :new, :create, :update, :destroy,
      edit: :update,
      delete: :destroy
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

  def activated?
    logged_in? && current_user.activated?
  end

  def user_is_owner?
    activated? && object.user_id == current_user.id
  end

  def user_owns_related_domain?
    return unless domain_id = object.domain_id
    return unless domain = Domain.find domain_id
    domain.user_id == current_user.id
  end

  def show?; false; end
  def create?; false; end
  def edit?; false; end
  def update?; false; end
  def destroy?; false; end
  def delete?; false; end

  def new?; logged_in?; end
end
