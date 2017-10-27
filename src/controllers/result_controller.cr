class ResultController < ApplicationController
  def index
    results = Result.all
    render("index.slang")
  end

  def show
    if result = Result.find params["id"]
      render("show.slang")
    else
      flash["warning"] = "Result with ID #{params["id"]} Not Found"
      redirect_to "/results"
    end
  end

  def new
    result = Result.new
    render("new.slang")
  end

  def create
    result = Result.new(params.to_h.select(["is_up", "check_id"]))

    if result.valid? && result.save
      flash["success"] = "Created Result successfully."
      redirect_to "/results"
    else
      flash["danger"] = "Could not create Result!"
      render("new.slang")
    end
  end

  def edit
    if result = Result.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "Result with ID #{params["id"]} Not Found"
      redirect_to "/results"
    end
  end

  def update
    if result = Result.find(params["id"])
      result.set_attributes(params.to_h.select(["is_up", "check_id"]))
      if result.valid? && result.save
        flash["success"] = "Updated Result successfully."
        redirect_to "/results"
      else
        flash["danger"] = "Could not update Result!"
        render("edit.slang")
      end
    else
      flash["warning"] = "Result with ID #{params["id"]} Not Found"
      redirect_to "/results"
    end
  end

  def destroy
    if result = Result.find params["id"]
      result.destroy
    else
      flash["warning"] = "Result with ID #{params["id"]} Not Found"
    end
    redirect_to "/results"
  end
end
