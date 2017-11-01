defmodule Meshi.SlackSender do
  def post_to_slack(encoded_msg) do
    HTTPoison.post(Application.get_env(:slack, :incoming_slack_webhook), encoded_msg)
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
