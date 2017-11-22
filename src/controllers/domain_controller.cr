class DomainController < ApplicationController
  authorize_with DomainPolicy, Domain
  require_logged_in

  private def domain_params
    params_hash = params.to_h
    params_hash.select([
      "name"
    ])
  end

  def index
    domains = policy_scope
    render "index.slang"
  end
end
