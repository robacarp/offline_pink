class RouteController < ApplicationController
  authorize_with RoutePolicy, Route
  require_logged_in

  private def route_params
    params_hash = params.to_h
    params_hash.select([
      "path",
      "expected_content"
    ]).merge({
      "use_ssl" => params_hash["use_ssl"] == "1"
    })
  end

  private def find_domain
    if domain = Domain.find params["domain_id"]?
      domain.not_nil!
    else
      flash["warning"] = "Domain could not be found"
      redirect_to_domains
      nil
    end
  end

  private def redirect_to_domain(domain_id : Int64?) : Nil
    if domain_id
      redirect_to "/domain/#{domain_id}"
    else
      redirect_to_domains
    end
  end

  private def expected_code
    code = params["expected_code"]?
    if code.nil? || code == ""
      200_i64
    else
      code.to_i64
    end
  end

  def new
    return unless domain = find_domain

    route = Route.new domain_id: domain.id
    authorize route
    render "new.slang"
  end

  def create
    return unless domain = find_domain

    route = Route.new domain_id: domain.id
    route.set_attributes route_params
    route.expected_code = expected_code

    authorize route

    if route.save
      flash["success"] = "Route monitoring will begin shortly."
      GetJob.new(route: route).enqueue
      redirect_to_domain domain.id
    else
      flash["danger"] = "Route could not be created."
      render "new.slang"
    end
  end

  def show
    if route = Route.find params["id"]
      authorize route
      result = route.last_result
      render "show.slang"
    else
      flash["warning"] = "Route doesnt exist"
      redirect_to_domains
    end
  end

  def delete
    if route = Route.find params["id"]
      authorize route
      render "delete.slang"
    else
      flash["warning"] = "Route doesnt exist."
      redirect_to_domains
    end
  end

  def destroy
    unless route = Route.find params["id"]
      flash["warning"] = "Route doesnt exist."
      redirect_to_domains
      return
    end

    authorize route

    unless params["confirm"] == "1"
      flash["info"] = "You must check the confirm box"
      skip_authorization
      return render "delete.slang"
    end

    if route.destroy
      flash["info"] = "Route deleted."
      redirect_to_domain route.domain_id
    else
      flash["danger"] = "Unable to delete route."
      redirect_to_domain route.domain_id
    end
  end
end
