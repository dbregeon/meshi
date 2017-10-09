defmodule Meshi.RestaurantView do
  use Meshi.Web, :view

  # def render("index.json", %{page: page}), do: page


  def render("index.json", %{restaurants: restaurants}) do
    %{
      restaurants: Enum.map(restaurants, &restaurant_json/1)
    }
  end

  def render("show.json", %{restaurant: restaurant}) do
    %{
      restaurant: restaurant_json(restaurant)
    }
  end

  def restaurant_json(restaurant) do
    %{
      name: restaurant.name,
      url: restaurant.url,
      posted_by: restaurant.posted_by,
      posted_on: restaurant.posted_on
    }
  end
end
