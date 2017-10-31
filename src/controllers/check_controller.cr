class CheckController < ApplicationController
  before_action do
    all do
      unless logged_in?
        redirect_to "/"
      end
    end
  end

  private def check_fields
    params.to_h.select [
      "ping_check",
      "get_request",
      "host",
      "url"
    ]
  end

  authorize_with CheckPolicy, Check

  def index
    checks = policy_scope
    render "index.slang"
  end

  def show
    if check = Check.find params["id"]
      authorize check
      render "show.slang"
    else
      flash["warning"] = "Check with ID #{params["id"]} Not Found"
      redirect_to "/checks"
    end
  end

  def new
    check = Check.new
    authorize check
    render "new.slang"
  end

  def create
    check = Check.new check_fields

    check.user = current_user

    if check.valid? && check.save
      flash["success"] = "Created Check successfully."
      redirect_to "/checks"
    else
      flash["danger"] = "Could not create Check!"
      render "new.slang"
    end
  end

  def edit
    if check = Check.find params["id"]
      render "edit.slang"
    else
      flash["warning"] = "Check with ID #{params["id"]} Not Found"
      redirect_to "/checks"
    end
  end

  def update
    if check = Check.find params["id"]
      check.set_attributes check_fields
      if check.valid? && check.save
        flash["success"] = "Updated Check successfully."
        redirect_to "/checks"
      else
        flash["danger"] = "Could not update Check!"
        render "edit.slang"
      end
    else
      flash["warning"] = "Check with ID #{params["id"]} Not Found"
      redirect_to "/checks"
    end
  end

  def destroy
    if check = Check.find params["id"]
      check.destroy
    else
      flash["warning"] = "Check with ID #{params["id"]} Not Found"
    end
    redirect_to "/checks"
  end
end
