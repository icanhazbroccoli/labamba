defmodule Labamba.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :name, :string
      add :description, :string
      add :date_start, :date
      add :date_end, :date
      add :location, :string
      add :location_lat, :float
      add :location_lon, :float

      timestamps()
    end

    create index(:events, [:name])
  end
end
