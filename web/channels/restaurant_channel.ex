defmodule Meshi.RestaurantChannel do
  use Phoenix.Channel
  use Meshi.Web, :channel

  def join("restaurants", _, socket), do: {:ok, socket}
end
