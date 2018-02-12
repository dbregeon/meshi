defmodule Meshi.RestaurantView do
  use Meshi.Web, :view

  # def render("index.json", %{page: page}), do: page


  def render("index.json", %{restaurants_with_opinion: restaurants_with_opinion}) do
    %{
      restaurants: Enum.map(restaurants_with_opinion, fn({restaurant, opinion}) -> restaurant_json(restaurant, opinion) end)
    }
  end

  def render("show.json", %{restaurant: restaurant, opinion: opinion}) do
    %{
      restaurant: restaurant_json(restaurant, opinion)
    }
  end

  def restaurant_json(restaurant, opinion) do
    %{
      id: restaurant.id,
      name: restaurant.name,
      url: restaurant.url,
      opinion: case opinion do
        nil -> "Neutral"
        o   -> o.value
      end,
      posted_by: restaurant.posted_by,
      posted_on: restaurant.posted_on
    }
  end
end
