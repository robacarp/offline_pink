Amber::Server.configure do |app|
  pipeline :web do
    plug Amber::Pipe::Error.new
    plug Amber::Pipe::Logger.new
    plug Amber::Pipe::Session.new
    plug Amber::Pipe::Flash.new
    plug PinkAuthorization::ErrorPipe.new
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
    get "/sessions",         SessionController, :new
    post "/sessions",        SessionController, :create
    get "/sessions/destroy", SessionController, :destroy

    # Registration
    get "/me/register",           UserController, :new
    post "/me/register",          UserController, :create
    get "/me/edit",               UserController, :edit
    post "/me/edit",              UserController, :update
    get "/me/activate", User::InvitesController, :edit
    post "/me/activate", User::InvitesController, :update

    # Domains
    get  "/my/domains",           DomainController, :index
    get  "/my/domains/new",       DomainController, :new
    post "/my/domains/new",       DomainController, :create
    get  "/domain/:id",           DomainController, :show
    get  "/domain/:id/delete",    DomainController, :delete
    delete "/domain/:id",         DomainController, :destroy
    get "/domain/:id/revalidate", DomainController, :revalidate

    # Monitors
    get "/domain/:domain_id/monitors/new",  MonitorController, :new
    post "/domain/:domain_id/monitors/new", MonitorController, :create
    get "/domain/:domain_id/monitors", MonitorController, :index
    get "/monitor/:id",              MonitorController, :show
    get "/monitor/:id/delete",       MonitorController, :delete
    delete "/monitor/:id",           MonitorController, :destroy

    # Hosts
    get "/host/:id/last_results", HostController, :show

    # Admin panel
    get "/admin", Admin::HomeController, :show
    get "/admin/users",    Admin::UserController, :index
    get "/admin/user/:id", Admin::UserController, :show
    post "/admin/user/:id/activate", Admin::UserController, :activate
    post "/admin/user/:id/deactivate", Admin::UserController, :deactivate

    get "/admin/invites",  Admin::InviteController, :index
    get "/admin/invites/new", Admin::InviteController, :new
    get "/admin/invite/:id", Admin::InviteController, :show
    post "/admin/invites", Admin::InviteController, :create
    delete "/admin/invite/:id", Admin::InviteController, :destroy

    get "/", HomeController, :index
  end

  routes :static do
    get "/*", Amber::Controller::Static, :index
  end
end
