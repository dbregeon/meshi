defmodule Meshi.Repo.Migrations.AddOpinionTable do
  use Ecto.Migration

  def change do
    create table(:opinions, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :restaurant_id, :int
      add :author, :string
      add :value, :string
      add :body, :text

      timestamps()
    end
  end
end
