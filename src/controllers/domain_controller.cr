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

    unless domain.save
      flash["danger"] = "Domain could not be created."
      return render "new.slang"
    end

    flash["success"] = "Domain monitoring will begin shortly."
    redirect_to "/domain/#{domain.id}"
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

    unless params["confirm"] == "1"
      flash["info"] = "You must check the confirm box"
      return render "delete.slang"
    end

    if domain.destroy
      flash["info"] = "Domain deleted."
      redirect_to_domains
    else
      flash["danger"] = "Unable to delete domain."
      redirect_to_domains
    end
  end

  def revalidate
    unless domain = Domain.find params["id"]
      flash["warning"] = "Domain doesnt exist."
      redirect_to_domains
      return
    end

    authorize domain

    domain.is_valid = true
    if domain.save
      flash["info"] = "Domain will be re-checked."
      # PingJob.new(domain: domain).enqueue
      redirect_to "/domain/#{domain.id}"
    else
      flash["danger"] = "Could not set domain for re-check."
      redirect_to "/domain/#{domain.id}"
    end
  end
end
