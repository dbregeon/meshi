defmodule Meshi.Opinion do
  use Ecto.Schema
  import Ecto.Changeset
  alias Meshi.Opinion

  @primary_key {:id, :binary_id, autogenerate: true}
  @derive {Phoenix.Param, key: :id}
  schema "opinions" do
    belongs_to :restaurant, Meshi.Restaurant

    field :author, :string
    field :value, :string
    field :body, :string

    timestamps()
  end

  def changeset(%Opinion{} = opinion, params) do
    opinion
    |> cast(params, [:author, :opinion, :body])
    |> validate_required([:restaurant_id, :author, :opinion, :body])
    |> assoc_constraint(:restaurant)
  end

  def id(user_email, restaurant_id) do
    UUID.uuid5("meshi", "#{user_email}:#{restaurant_id}")
  end
end
