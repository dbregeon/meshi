defmodule Meshi.Router do
  use Meshi.Web, :router
  require Ueberauth
  require Logger

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

  pipeline :slack do
    plug :accepts, ["json"]
    plug Plug.Parsers, parsers: [:urlencoded]
    plug :token_match
  end

  scope "/api", Meshi do
    pipe_through :api # Use the default api stack

    resources "/restaurants", RestaurantController, only: [:index, :show, :create, :update, :delete]
  end

  scope "/", Meshi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/slack/webhook", Meshi do
    pipe_through :slack # Use the slack stack

    # Slack will periodically send get requests
    # to make sure the bot is still alive.
    get "/", SlackController, :ping

    post "/", SlackController, :query
  end

  scope "/auth", Meshi do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  defp token_match(conn, _params) do
    slack_token = Application.get_env(:meshi, :slack_token)
    case conn.params do
      %{"token" => token} when token == slack_token ->
          conn
      _ ->
        conn |> put_status(:bad_request) |> send_resp(404, "bad request") |> halt
    end
  end
  # Other scopes may use custom stacks.
  # scope "/api", Meshi do
  #   pipe_through :api
  # end
end
