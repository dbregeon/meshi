defmodule Meshi.OpinionController do
  use Meshi.Web, :controller
  require Logger

  alias Meshi.Opinion

  def show(conn, %{"restaurant_id" => restaurant_id}) do
    opinion = Repo.get(Opinion, String.to_integer(restaurant_id))

    render conn, "show.json", opinion: opinion
  end

  def create(conn, params) do
    user = Meshi.Guardian.Plug.current_resource(conn)
    opinion_id = Opinion.id(user.email, params.restaurant_id)
    changeset =
       Opinion.changeset(%Opinion{id: opinion_id, author: user.email}, params)
    case Repo.insert(changeset) do
      {:ok, opinion} ->
       Meshi.Endpoint.broadcast(
        "opinions",
        "new",
        opinion
       )
       conn
         |> put_status(:created)
         |> render("show.json", opinion: opinion)
      {:error, changeset} ->
        Logger.debug "Failed to insert: #{inspect(changeset)}"
        json conn |> put_status(:bad_request), %{errors: ["unable to create opinion"] }
    end
  end

  def update(conn, %{"id" => id} = params) do
    user = Meshi.Guardian.Plug.current_resource(conn)
    opinion = Repo.get(Opinion, id)
    if opinion && opinion.author == user.email do
      changeset = Opinion.changeset(opinion, params)
      case Repo.update(changeset) do
        {:ok, opinion} ->
          Meshi.Endpoint.broadcast(
           "opinions",
           "update",
           opinion
          )
          json conn |> put_status(:ok), opinion
        {:error, _changeset} ->
          json conn |> put_status(:bad_request),
            %{errors: ["bad update"] }
      end
    else
      json conn |> put_status(:not_found),
                   %{errors: ["invalid opinion"] }
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Meshi.Guardian.Plug.current_resource(conn)
    opinion = Repo.get(Opinion, id)
    if opinion && opinion.author == user.email do
      case Repo.delete(opinion) do
        {:ok, opinion} ->
          Meshi.Endpoint.broadcast(
           "opinions",
           "remove",
           opinion
          )
          conn
           |> put_status(:ok)
           |> render("show.json", opinion: opinion)
        {:error, _changeset} ->
          json conn |> put_status(:bad_request),
            %{errors: ["bad update"] }
      end
    else
      json conn |> put_status(:not_found),
                   %{errors: ["invalid opinion"] }
    end
  end
end
