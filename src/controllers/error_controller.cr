# Error Controller
# Ensure Amber::Pipe::Error.new is inside config/router.cr pipelines
# Put error templates inside src/views/error/
class Amber::Controller::Error < Amber::Controller::Base
  LAYOUT = "application.slang"

  # def forbidden
  #   render("403.slang")
  # end

  # def not_found
  #   render("404.slang")
  # end

  # def internal_server_error
  #   render("500.slang")
  # end
end
