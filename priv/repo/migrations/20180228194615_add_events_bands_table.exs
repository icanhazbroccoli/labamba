defmodule Labamba.Repo.Migrations.AddEventBandTable do
  use Ecto.Migration

  def change do
    create table(:events_bands, primary_key: false) do
      add :event_id, references(:events)
      add :band_id, references(:bands)
      add :performance_date, :date
    end

    create unique_index(:events_bands, [:event_id, :band_id])
  end
end
