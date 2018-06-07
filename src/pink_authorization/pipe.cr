module PinkAuthorization
  class ErrorPipe < Amber::Pipe::Base
    def call(context : HTTP::Server::Context)
      call_next context
    rescue ex : AccessDenied
      response = render_error context
      context.response.status_code = 401
      puts ex.message
      context.response.print response
      context.response.close
    end

    private def render_error(context)
      error = ErrorController.new context
      error.access_denied
    rescue ex : Exception
      "Access denied exception was thrown. Additionally, while attempting to render an error page, a further exception was thrown."
    end
  end
end
