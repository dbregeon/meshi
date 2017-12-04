defmodule Meshi.RestaurantChannelTest do
  use Meshi.ChannelCase

  alias Meshi.RestaurantChannel

  test "broadcast events after successful join" do
    {:ok, _, _socket} =
    socket()
    |> subscribe_and_join(
      RestaurantChannel,
      "restaurants"
    )

    Meshi.Endpoint.broadcast(
     "restaurants",
     "new",
     %{test: "test"}
    )

    assert_broadcast "new", %{test: "test"}

  end

end
