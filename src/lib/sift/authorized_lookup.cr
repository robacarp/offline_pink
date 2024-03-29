module Sift
  module AuthorizedLookup
    macro authorized_lookup(model, explicit_action = nil, &block)
      {%
        concrete_model = model.id
        getter = model.id.downcase.gsub(/:/, "")
        ivar = ("@_" + getter.stringify).id
        policy_class = model.id + "Policy"
        query_class = model.id + "Query"
        inferred_action = @type.id.split("::").last.downcase.id.symbolize
      %}

      before lookup_and_authorize

      {{ ivar }} : {{ concrete_model }}?

      def {{ getter }}
        # the #find(id) call below will return a model or raise 404
        {{ ivar }}.not_nil!
      end

      def policy_object_lookup : {{ concrete_model }}
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
        {{ explicit_action }} || {{ inferred_action }}
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
          # Log the unathorized request
          Log.warn { "Sift Unauthorized: #{policy_class}##{policy_class.resolve policy_action} did not authorize a '#{policy_action}' request for #{ {{ concrete_model }} }##{id}. This will render as a 404." }

          # pretend we don't even know that record exists
          raise Avram::RecordNotFoundError.new :{{ getter }}, id
        end
      end
    end
  end
end
