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

  pipeline :admin do
    plug IssueSeekerWeb.Plugs.Authorize, admin: true
  end

  scope "/", IssueSeekerWeb do
    pipe_through :browser

    get "/", PageController, :index

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
