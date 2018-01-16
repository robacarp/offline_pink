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

  def show
    if domain = Domain.find params["id"]
      authorize domain
      render "show.slang"
    else
      flash["warning"] = "Domain doesnt exist."
      redirect_to_domains
    end
  end

  def new
    domain = Domain.new
    authorize domain
    render "new.slang"
  end

  def create
    domain = Domain.new domain_params
    domain.user = current_user
    authorize domain

    if domain.valid? && domain.save
      flash["success"] = "Domain monitoring will begin shortly."
      PingJob.new(domain: domain).enqueue
      redirect_to_domains
    else
      flash["danger"] = "Domain could not be created."
      render "new.slang"
    end
  end

  def delete
    if domain = Domain.find params["id"]
      authorize domain
      render "delete.slang"
    else
      flash["warning"] = "Domain doesnt exist."
      redirect_to_domains
    end
  end

  def destroy
    unless domain = Domain.find params["id"]
      flash["warning"] = "Domain doesnt exist."
      redirect_to_domains
      return
    end

    authorize domain

    if domain.destroy
      flash["info"] = "Domain deleted."
      redirect_to_domains
    else
      flash["error"] = "Unable to delete domain."
      redirect_to_domains
    end
  end
end
