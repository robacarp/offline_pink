module Sift
  module AuthorizedCreate
    macro authorize_create(operation_class, *params, **named_params, &block)
      {%
        action_namespace = @type.id.split("::")[0..-2].join("::").id
        model = run("../pluralizer.cr", action_namespace, "singularize")
        policy_class = model + "Policy"
        create_policy_class = policy_class + "::Create"
      %}

      %operation = {{ operation_class }}.new(*{{ params }}, **{{ named_params }})

      unless {{ create_policy_class }}.new(current_user, %operation).authorize
        raise Sift::NotAuthorized.new("Not authorized to create")
      end

      %operation.sift_authorized!
      _authorized!

      {% if block %}
        {{ block.args[0] }} = %operation

        if %operation.save
          {{ block.args[1] }} = %operation.record
        else
          {{ block.args[1] }} = nil
        end

        begin
          {{ block.body }}
        end

      {% else %}
        {% raise "authorize_create expects a block" %}
      {% end %}
    end
  end
end
