defmodule Meshi.Repo.Migrations.CreateRestaurants do
  use Ecto.Migration

  def change do
    create table(:restaurants) do
      add :name, :string
      add :url, :binary
      add :posted_by, :string
      add :posted_on, :utc_datetime

      timestamps()
    end

  end
end
