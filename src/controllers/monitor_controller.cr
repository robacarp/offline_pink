class MonitorController < ApplicationController
  authorize_with MonitorPolicy, Monitor
  require_logged_in

  private def find_domain
    if domain = Domain.find params["domain_id"]?
      domain.not_nil!
    else
      flash["warning"] = "Domain could not be found"
      redirect_to_domains
      nil
    end
  end

  private def params_for_monitor_type
    case params["monitor_type"]
    when Monitor::VALID_TYPES[:ping].to_s
      ping_params
    when Monitor::VALID_TYPES[:http].to_s
      http_params
    else
      {} of String => String | Bool | Int32 | Nil
    end
  end

  private def ping_params
    params.to_h.select(["monitor_type"])
  end

  private def http_params
    params_hash = params.to_h
    params_hash.select([
      "monitor_type",
      "http_path",
      "http_expected_content",
    ]).merge({
      "http_use_ssl"              => params_hash["http_use_ssl"] == "1",
      "http_expected_status_code" => params_hash["http_expected_status_code"].to_i32?,
    })
  end

  def index
    return unless domain = find_domain
    authorize domain, with: DomainPolicy, for: :show
    render "index.slang"
  end

  def show
    if monitor = Monitor.find params[:id]
      authorize monitor
      domain = monitor.domain
      render "show.slang"
    else
      flash["danger"] = "Monitor not found"
      redirect_to_domains
    end
  end

  def new
    return unless domain = find_domain
    monitor = Monitor.new domain_id: domain.id
    authorize monitor

    render "new.slang"
  end

  def create
    return unless domain = find_domain
    monitor = Monitor.new domain_id: domain.id
    monitor.set_attributes params_for_monitor_type

    authorize monitor

    if monitor.save
      flash["success"] = "Monitoring will begin shortly."
      MonitorJob.new(domain: domain).enqueue
      redirect_to_domain_monitors domain
    else
      flash["danger"] = "Monitor could not be created."
      render "new.slang"
    end
  end

  def delete
    if monitor = Monitor.find params[:id]
      authorize monitor
      domain = monitor.domain
      render "delete.slang"
    else
      flash["danger"] = "Monitor not found"
      redirect_to_domains
    end
  end

  def destroy
    unless monitor = Monitor.find params[:id]
      flash["danger"] = "Monitor not found"
      redirect_to_domains
      return
    end

    authorize monitor
    domain = monitor.domain

    unless params["confirm"] == "1"
      flash["info"] = "You must check the confirm box"
      return render "delete.slang"
    end

    if monitor.destroy
      flash["info"] = "Monitor deleted."
      redirect_to_domain_monitors domain
    else
      flash["danger"] = "Unable to delete monitor."
      redirect_to_domains
    end
  end

  private def redirect_to_domain_monitors(domain : Domain)
    redirect_to "/domain/#{domain.id}/monitors"
  end
end
