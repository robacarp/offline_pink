abstract class BrowserAction < Lucky::Action
  include Lucky::ProtectFromForgery
  accepted_formats [:html, :json], default: :html

  include Authentic::ActionHelpers(User)
  include Auth::TestBackdoor
  include Auth::RequireSignIn
  include PolymorphicOwnership

  expose current_user

  # This method tells Authentic how to find the current user
  private def find_current_user(id) : User?
    UserQuery.new.id(id).first?
  end

  def authorize(object, with policy, to action : Symbol = :read)
    authorized = policy.new(current_user, object).authorize(action)
  end

  macro authorized_lookup(model, &block)
    {% getter = model.id.downcase %}
    {% ivar = ("@_" + getter.stringify).id %}
    {% policy_class = model.id + "Policy" %}
    {% query_class = model.id + "Query" %}
    {% policy_action = @type.id.split("::").last.downcase.id.symbolize %}

    {{ ivar }} : {{ model }}?

    def {{ getter }}
      # the #find(id) call below will return a model or raise 404
      {{ ivar }}.not_nil!
    end

    def policy_object_lookup : {{ model }}
      %query = policy_query.new
      {{ block.args.first }} = %query

      %yielded_query = begin
        {{ block.body }}
      end

      %yielded_query.find(id)
    end

    def policy_action
      {{ policy_action }}
    end

    def policy_class : {{ policy_class }}.class
      {{ policy_class }}
    end

    def policy_query : {{ query_class }}.class
      {{ query_class }}
    end

    def lookup_and_authorize
      {{ ivar }} = policy_object_lookup
      authorized = authorize {{ getter }}, with: policy_class, to: policy_action

      if authorized
        continue
      else
        raise Avram::RecordNotFoundError.new :{{ model }}, id
      end
    end

    before lookup_and_authorize
  end
end
