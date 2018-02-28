defmodule Labamba.Repo.Migrations.AddEventsBandsTable do
  use Ecto.Migration

  def change do
    create table(:events_bands, primary_key: false) do
      add :event_id, references(:events)
      add :band_id, references(:bands)
    end
  end
end
