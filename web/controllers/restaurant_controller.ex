defmodule Meshi.RestaurantController do
  use Meshi.Web, :controller
  require Logger

  alias Meshi.Restaurant

  def index(conn, _params) do
    import Ecto.Query, only: [from: 2]

    user_email = get_session(conn, :current_user).email

    restaurants = Repo.all(Restaurant)
    opinions =
      Repo.all(from o in Meshi.Opinion, where: o.author == ^user_email)
      |> Enum.map(fn [o] -> {o.restaurant_id, o} end)
      |> Map.new
    restaurants_with_opinion = restaurants |> Enum.map(fn(r) -> {r, Map.get(opinions, r.id)} end)

    render conn, "index.json", restaurants_with_opinion: restaurants_with_opinion
  end

  def show(conn, %{"id" => id}) do
    user = get_session(conn, :current_user)
    restaurant = Repo.get(Restaurant, String.to_integer(id))
    opinion = Repo.get(Meshi.Opinion, Meshi.Opinion.id(user.email, id))

    render conn, "show.json", restaurant: restaurant, opinion: opinion
  end

  def create(conn, params) do
    user = get_session(conn, :current_user)
    changeset = Restaurant.changeset(%Restaurant{posted_on:  DateTime.utc_now, posted_by: user.email}, params)
    case Repo.insert(changeset) do
      {:ok, restaurant} ->
       Meshi.Endpoint.broadcast(
        "restaurants",
        "new",
        restaurant
       )
       conn
         |> put_status(:created)
         |> render("show.json", restaurant: restaurant)
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
          Meshi.Endpoint.broadcast(
           "restaurants",
           "update",
           restaurant
          )
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

  def delete(conn, %{"id" => id}) do
    restaurant = Repo.get(Restaurant, id)
    if restaurant do
      case Repo.delete(restaurant) do
        {:ok, restaurant} ->
          Meshi.Endpoint.broadcast(
           "restaurants",
           "remove",
           restaurant
          )
          conn
           |> put_status(:ok)
           |> render("show.json", restaurant: restaurant)
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
