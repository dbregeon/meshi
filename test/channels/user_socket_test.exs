defmodule Meshi.UserSocketTest do
  use Meshi.ChannelCase
  alias Meshi.UserSocket


  test "authenticates the user of the channel" do
    {:ok, jwt, _} = Guardian.encode_and_sign(Meshi.Guardian, %{id: "Test User"})
    assert {:ok, _authed_socket} = UserSocket.connect(%{"token" => "#{jwt}"}, socket())
  end

  test "rejects  the user of the channel" do
    assert :error = UserSocket.connect(%{"token" => "other"}, socket())
  end

end
