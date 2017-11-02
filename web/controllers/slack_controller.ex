defmodule Meshi.SlackController do
  use Meshi.Web, :controller

  def ping(conn, _params) do
    send_resp(conn, 200, "")
  end

  def query(conn, _params) do
    sendmsg "Yeah!"
    send_resp(conn, 200, "")
  end

  def post_to_slack(encoded_msg) do
    HTTPoison.post(Application.get_env(:meshi, :incoming_slack_webhook), encoded_msg)
  end

  def sendmsg(msg) do
    Poison.encode!(%{
      "username" => "meshi-bot",
      "icon_emoji" => ":cloud:",
      "text" => msg
      })
    |> post_to_slack
  end
end
