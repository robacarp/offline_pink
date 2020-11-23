module AuthorizedScope
  # override these methods per action if needed
  def _policy_query_class ; end
  def _scope_class ; end

  macro authorized_scope_for(model, &block)
    {%
      query_class = model.id + "Query"
      policy_class = model.id + "Policy"
      scope_class = policy_class + "::Scope"
    %}

    %query_class = _policy_query_class || {{ query_class }}
    %scope_class = _scope_class || {{ scope_class }}

    scoped_query %scope_class, with: %query_class.new
  end
end
