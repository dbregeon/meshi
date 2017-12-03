defmodule Meshi.RestaurantChannelTest do
  use Meshi.ChannelCase

  alias Meshi.RestaurantChannel

  test "broadcast events after successful join" do
    {:ok, _, _socket} =
    socket()
    |> subscribe_and_join(
      RestaurantChannel,
      "restaurants",
      %{claims: "Test Claim", resource: "Test Resource"}
    )

    Meshi.Endpoint.broadcast(
     "restaurants",
     "new",
     %{test: "test"}
    )

    assert_broadcast "new", %{test: "test"}

  end

  test "unauthenticated users cannot join" do
    assert {:error, %{error: "not authorized, are you logged in?"}} =
      socket()
      |> Phoenix.ChannelTest.join(RestaurantChannel, "restaurants")
  end

end
