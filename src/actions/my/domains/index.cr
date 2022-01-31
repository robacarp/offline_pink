class My::Domains::Index < BrowserAction
  ensure_feature_permitted :domain_monitoring

  get "/my/domains" do
    domains = DomainQuery.new.user_id(current_user.id)
    html IndexPage, domains: domains
  end
end
