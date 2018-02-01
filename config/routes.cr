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
    plug Amber::Pipe::Logger.new
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

    # Domains
    get  "/my/domains",           DomainController, :index
    get  "/my/domains/new",       DomainController, :new
    post "/my/domains/new",       DomainController, :create
    get  "/domain/:id",           DomainController, :show
    get  "/domain/:id/delete",    DomainController, :delete
    delete "/domain/:id",         DomainController, :destroy
    get "/domain/:id/revalidate", DomainController, :revalidate

    # Routes
    get  "/domain/:domain_id/routes/new", RouteController, :new
    post "/domain/:domain_id/routes/new", RouteController, :create
    get "/route/:id",                     RouteController, :show
    get "/route/:id/delete",              RouteController, :delete
    delete "/route/:id",                  RouteController, :destroy

    # IpAddresses
    get "/ip_address/:id/delete", IpAddressController, :delete
    delete "/ip_address/:id",     IpAddressController, :destroy

    # Admin panel
    get "/admin", Admin::HomeController, :show
    get "/admin/users",    Admin::UserController, :index
    get "/admin/user/:id", Admin::UserController, :show

    get "/", HomeController, :index
  end

  routes :static do
    get "/*", Amber::Controller::Static, :index
  end
end
