defmodule Meshi.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Meshi.Restaurant

  schema "restaurants" do
    has_many :opinions, Meshi.Opinion

    field :name, :string
    field :posted_by, :string
    field :posted_on, :utc_datetime
    field :url, :binary

    timestamps()
  end

  @doc false
  def changeset(%Restaurant{} = restaurant, attrs) do
    restaurant
    |> cast(attrs, [:name, :url, :posted_by, :posted_on])
    |> validate_required([:name, :url, :posted_by, :posted_on])
    |> validate_url(:url)
  end

  def validate_url(changeset, field) do
    validate_change changeset, field, fn _, url ->
      case url |> String.to_charlist |> :http_uri.parse do
        {:ok, _} -> []
        {:error, msg} -> [{field, "invalid url: #{inspect msg}"}]
      end
    end
  end
end
