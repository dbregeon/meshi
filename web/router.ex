defmodule Meshi.Router do
  use Meshi.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", Meshi do
    pipe_through :api # Use the default api stack

    resources "/restaurants", RestaurantController, only: [:index, :show, :create, :update]
  end

  scope "/", Meshi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Meshi do
  #   pipe_through :api
  # end
end
