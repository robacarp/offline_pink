class IpAddressController < ApplicationController
  authorize_with IpAddressPolicy, IpAddress
  require_logged_in

  def delete
    if ip_address = IpAddress.find params["id"]
      authorize ip_address
      domain = ip_address.domain.not_nil!

      render "delete.slang"
    else
      flash["warning"] = "IP address doesnt exist."
      redirect_to domains_path
    end
  end

  def destroy
    unless ip_address = IpAddress.find params["id"]
      flash["warning"] = "IP address doesnt exist."
      redirect_to domains_path
      return
    end

    domain = ip_address.domain.not_nil!

    unless params["confirm"] == "1"
      flash["info"] = "You must check the confirm box"
      skip_authorization
      return render "delete.slang"
    end

    authorize ip_address

    if ip_address.destroy
      flash["info"] = "IP address forgotten."
      redirect_to domains_path
    else
      flash["error"] = "Unable to forget IP address."
      redirect_to domains_path
    end
  end
end
