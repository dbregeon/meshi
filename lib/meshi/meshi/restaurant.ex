defmodule Meshi.Restaurant do
  use Ecto.Schema
  import Ecto.Changeset
  alias Meshi.Restaurant

  schema "restaurants" do
    field :name, :string
    field :posted_by, :string
    field :posted_on, :utc_datetime
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(%Restaurant{} = restaurant, attrs) do
    restaurant
    |> cast(attrs, [:name, :url, :posted_by, :posted_on])
    |> validate_required([:name, :url, :posted_by, :posted_on])
  end
end
