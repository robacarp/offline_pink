class ErrorController < ApplicationController
  LAYOUT = "application.slang"

  def not_found
    render("404.slang")
  end

  def access_denied
    render "access_denied.slang"
  end
end
