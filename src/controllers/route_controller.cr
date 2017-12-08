class RouteController < ApplicationController
  authorize_with RoutePolicy, Route
  require_logged_in

  private def route_params
    params.to_h.select([
      "path",
      "expected_content",
      "expected_code",
      "use_ssl"
    ])
  end

  def new
    domain = Domain.find params["domain_id"]
    raise "Domain not found" unless domain
    route = Route.new domain_id: domain.id
    authorize route
    render "new.slang"
  end

  def create
    domain = Domain.find params["domain_id"]
    raise "Domain not found" unless domain
    route = Route.new domain_id: domain.id

    route.set_attributes route_params

    authorize route

    if route.valid? && route.save
      flash["success"] = "Route monitoring will begin shortly."
      redirect_to "/domain/#{domain.id}"
    else
      flash["danger"] = "Route could not be created."
      render "new.slang"
    end
  end
end
