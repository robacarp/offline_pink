module Theme::Form
  include Lucky::HTMLPage

  def themed_form(action : Lucky::RouteHelper | Lucky::Action.class, &block)
    form_for action, class: "rounded pt-6 pb-8 mb-4", &block
  end
end
