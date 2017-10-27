class CheckController < ApplicationController
  before_action do
    all do
      unless logged_in?
        redirect_to "/"
      end
    end
  end

  def index
    checks = current_user.checks
    render("index.slang")
  end

  def show
    if check = Check.find params["id"]
      render("show.slang")
    else
      flash["warning"] = "Check with ID #{params["id"]} Not Found"
      redirect_to "/checks"
    end
  end

  def new
    check = Check.new
    render("new.slang")
  end

  def create
    check = Check.new(params.to_h.select(["type", "reference"]))

    if check.valid? && check.save
      flash["success"] = "Created Check successfully."
      redirect_to "/checks"
    else
      flash["danger"] = "Could not create Check!"
      render("new.slang")
    end
  end

  def edit
    if check = Check.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "Check with ID #{params["id"]} Not Found"
      redirect_to "/checks"
    end
  end

  def update
    if check = Check.find(params["id"])
      check.set_attributes(params.to_h.select(["type", "reference"]))
      if check.valid? && check.save
        flash["success"] = "Updated Check successfully."
        redirect_to "/checks"
      else
        flash["danger"] = "Could not update Check!"
        render("edit.slang")
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
