require "lexbor"

class HtmlBeautificationHandler
  include HTTP::Handler

  def initialize(@enabled = false)
  end

  def call(context : HTTP::Server::Context)
    unless @enabled
      return call_next context
    end

    to_client = context.response.output
    unpretty = IO::Memory.new
    context.response.output = unpretty

    call_next context

    if context.response.headers["Content-Type"]? == "text/html"
      to_client << Lexbor::Parser.new(unpretty.to_s).to_pretty_html
    else
      to_client << unpretty
    end

    context.response.output = to_client
  end
end
