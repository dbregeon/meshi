defmodule Meshi.RestaurantChannel do
  use Phoenix.Channel
  use Meshi.Web, :channel

  def join("restaurants", %{claims: _claim, resource: _resource}, socket), do: {:ok, socket}

  def join("restaurants", _, _socket), do: {:error, %{error: "not authorized, are you logged in?"}}
end
