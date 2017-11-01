defmodule Meshi.Slack.Plug do
  def init(opts), do: opts
  def call(conn, opts) do
    conn
    |> Plug.Conn.assign(:name, Keyword.get(opts, :name, "Slack Plug"))
    |> Meshi.Slack.Router.call(opts)
  end
end

defmodule Meshi.Slack.Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    Meshi.SlackSender.sendmsg "Yeah!"
    send_resp(conn, 200, ~s({"text":"ok"}))
  end
  match _, do: send_resp(conn, 404, "Not found")
end

defmodule Meshi.Router do
  use Meshi.Web, :router
  require Ueberauth

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

    resources "/restaurants", RestaurantController, only: [:index, :show, :create, :update, :delete]
  end

  scope "/", Meshi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    forward "/slack/webhook", Slack.Plug, name: "Hello Slack"
  end

  scope "/auth", Meshi do
    pipe_through :browser

    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
    post "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Other scopes may use custom stacks.
  # scope "/api", Meshi do
  #   pipe_through :api
  # end
end
