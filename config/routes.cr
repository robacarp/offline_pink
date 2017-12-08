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

  pipeline :static do
    plug Amber::Pipe::Error.new
    plug HTTP::StaticFileHandler.new("./public")
    plug HTTP::CompressHandler.new
  end

  routes :web do
    # Sessions
    get "/sessions/new",     SessionController, :new
    post "/sessions/create", SessionController, :create
    get "/sessions/destroy", SessionController, :destroy

    # Registration
    get "/me/register",           UserController, :new
    post "/me/register",          UserController, :create
    get "/me/edit",               UserController, :edit
    post "/me/edit",              UserController, :update
    get "/me/destroy_account",    UserController, :delete
    delete "/me/destroy_account", UserController, :destroy

    # Domains
    get  "/my/domains",     DomainController, :index
    get  "/my/domains/new", DomainController, :new
    post "/my/domains/new", DomainController, :create
    get "/domain/:id", DomainController, :show

    # Routes
    get  "/domain/:domain_id/routes/new", RouteController, :new
    post "/domain/:domain_id/routes/new", RouteController, :create

    get "/", HomeController, :index
  end

  routes :static do
    get "/*", StaticController, :index
  end
end
