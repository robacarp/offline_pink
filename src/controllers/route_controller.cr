class RouteController < ApplicationController
  authorize_with RoutePolicy, Route
  require_logged_in

  private def route_params
    params_hash = params.to_h
    params_hash.select([
      "path",
      "expected_content"
    ]).merge({
      "use_ssl" => params_hash["use_ssl"] == "1",
    })
  end

  def expected_code
    code = params["expected_code"]?
    if code.nil? || code == ""
      200_i64
    else
      code.to_i64
    end
  end

  def find_domain
    if domain = Domain.find params["domain_id"]
      domain.not_nil!
    else
      flash["warning"] = "Domain could not be found"
      redirect_to "/my/domains"
      nil
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

    if route.valid? && route.save
      flash["success"] = "Route monitoring will begin shortly."
      redirect_to "/domain/#{domain.id}"
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
      redirect_to "/my/domains"
    end
  end

  def delete
    if route = Route.find params["id"]
      authorize route
      render "delete.slang"
    else
      flash["warning"] = "Route doesnt exist."
      redirect_to "/my/domains"
    end
  end

  def destroy
    unless route = Route.find params["id"]
      flash["warning"] = "Route doesnt exist."
      redirect_to "/my/domains"
      return
    end

    authorize route

    if route.destroy
      flash["info"] = "Route deleted."
      redirect_to "/my/domains"
    else
      flash["error"] = "Unable to delete route."
      redirect_to "/my/domains"
    end
  end
end
