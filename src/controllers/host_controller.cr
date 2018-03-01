class HostController < ApplicationController
  authorize_with HostPolicy, Host
  require_logged_in

  def show
    unless host = Host.find params[:id]
      flash["warning"] = "Host could not be found"
      redirect_to_domains
      return
    end

    authorize host
    domain = host.domain

    render "show.slang"
  end
end
