defmodule IssueSeekerWeb.Router do
  use IssueSeekerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug IssueSeekerWeb.Plugs.Session
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug IssueSeekerWeb.Plugs.Authorize
  end

  pipeline :with_profile do
    plug IssueSeekerWeb.Plugs.Authorize, has_profile: true
  end

  pipeline :admin do
    plug IssueSeekerWeb.Plugs.Authorize, admin: true
  end

  scope "/", IssueSeekerWeb do
    pipe_through :browser

    get "/", PageController, :index
    scope "/projects" do
      get "/new", ProjectController, :new
      post "/", ProjectController, :create
      get "/", ProjectController, :index
      get "/:id", ProjectController, :show
    end

    scope "/issues" do
      get "/projects/:project_id", IssueController, :index
      get "/:id", IssueController, :show
    end

    scope "/" do
      pipe_through :auth

      get "/self", UserController, :self

      scope "/profiles" do
        get "/", ProfileController, :show
        get "/new", ProfileController, :new
        get "/edit", ProfileController, :edit
        post "/", ProfileController, :create
        put "/", ProfileController, :update
      end
    end

    scope "/" do
      pipe_through :admin

      scope "/projects" do
        get "/list/pending_aproval", ProjectController, :pending_aproval
        get "/edit/:id", ProjectController, :edit
        put "/:id", ProjectController, :update
      end
    end

    scope "/" do
      pipe_through :with_profile

      scope "/recommendations" do
        get "/projects", RecommendationController, :projects
      end
    end
  end

  scope "/auth", IssueSeekerWeb do
    pipe_through :browser

    get "/github", AuthController, :request
    get "/github/callback", AuthController, :callback
    get "/signout", AuthController, :signout
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: IssueSeekerWeb.Telemetry
    end
  end
end
