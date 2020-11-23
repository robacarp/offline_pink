module AuthorizedLookup
  macro authorized_lookup(model, &block)
    {% getter = model.id.downcase %}
    {% ivar = ("@_" + getter.stringify).id %}
    {% policy_class = model.id + "Policy" %}
    {% query_class = model.id + "Query" %}
    {% policy_action = @type.id.split("::").last.downcase.id.symbolize %}

    before lookup_and_authorize

    {{ ivar }} : {{ model }}?

    def {{ getter }}
      # the #find(id) call below will return a model or raise 404
      {{ ivar }}.not_nil!
    end

    def policy_object_lookup : {{ model }}
      %query = policy_query.new

      {% if block %}
        {{ block.args.first }} = %query

        %yielded_query = begin
          {{ block.body }}
        end
      {% else %}
        %yielded_query = %query
      {% end %}

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
  end

end
