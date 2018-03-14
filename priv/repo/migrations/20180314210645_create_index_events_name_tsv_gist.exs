defmodule Labamba.Repo.Migrations.CreateIndexEventsNameTsvGist do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX events_name_tsv_gist ON events USING gist(name_tsv)"
  end

  def down do
    execute "DROP INDEX events_name_tsv_gist"
  end
end
