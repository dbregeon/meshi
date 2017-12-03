defmodule Meshi.LayoutView do
  use Meshi.Web, :view

  def socket_url(current_user) do
     "#{socket_url()}?token=#{token(current_user)}"
  end

  def token(current_user) do
    {ok, jwt, _} = Guardian.encode_and_sign(Meshi.Guardian, current_user)
    jwt
  end

  def socket_url, do: System.get_env("WEBSOCKET_URL") || "ws://localhost:4000/socket/websocket"
end
