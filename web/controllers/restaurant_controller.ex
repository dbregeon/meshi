defmodule Meshi.RestaurantController do
  use Meshi.Web, :controller
  require Logger

  alias Meshi.Restaurant

  def index(conn, _params) do
    restaurants = Repo.all(Restaurant)

    render conn, "index.json", restaurants: restaurants
  end

  def show(conn, %{"id" => id}) do
    restaurant = Repo.get(Restaurant, String.to_integer(id))

    render conn, "show.json", restaurant: restaurant
  end

  def create(conn, params) do
    changeset = Restaurant.changeset(%Restaurant{posted_on:  DateTime.utc_now, posted_by: "Test"}, params)
    case Repo.insert(changeset) do
      {:ok, restaurant} ->
       conn
         |> put_status(:created)
         |> render "show.json", restaurant: restaurant
      {:error, changeset} ->
        Logger.debug "Failed to insert: #{inspect(changeset)}"
        json conn |> put_status(:bad_request), %{errors: ["unable to create restaurant"] }
    end
  end

  def update(conn, %{"id" => id} = params) do
    restaurant = Repo.get(Restaurant, id)
    if restaurant do
      changeset = Restaurant.changeset(restaurant, params)
      case Repo.update(changeset) do
        {:ok, restaurant} ->
          json conn |> put_status(:ok), restaurant
        {:error, _changeset} ->
          json conn |> put_status(:bad_request),
            %{errors: ["bad update"] }
      end
    else
      json conn |> put_status(:not_found),
                   %{errors: ["invalid restaurant"] }
    end
  end
end
