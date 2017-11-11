Amber::Server.configure do |app|
  pipeline :web do
    # Plug is the method to use connect a pipe (middleware)
    # A plug accepts an instance of HTTP::Handler
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    # plug Amber::Pipe::CSRF.new
  end

  # All static content will run these transformations
  pipeline :static do
    plug Amber::Pipe::Error.new
    plug HTTP::StaticFileHandler.new("./public")
    plug HTTP::CompressHandler.new
  end

  routes :static do
    # Each route is defined as follow
    # verb resource : String, controller : Symbol, action : Symbol
    get "/*", StaticController, :index
  end

  routes :web do
    get "/sessions/new",     SessionController, :new
    post "/sessions/create", SessionController, :create
    get "/sessions/destroy", SessionController, :destroy

    get "/me/register",           UserController, :new
    post "/me/register",          UserController, :create
    get "/me/edit",               UserController, :edit
    post "/me/edit",              UserController, :update
    get "/me/destroy_account",    UserController, :delete
    delete "/me/destroy_account", UserController, :destroy

    resources "/checks", CheckController

    get "/", HomeController, :index
  end
end
