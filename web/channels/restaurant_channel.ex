defmodule Meshi.RestaurantChannel do
  use Phoenix.Channel

  require Logger

  def join("restaurants", _, socket), do: {:ok, socket}
end
