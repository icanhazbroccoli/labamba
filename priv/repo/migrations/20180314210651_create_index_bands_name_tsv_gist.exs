defmodule Labamba.Repo.Migrations.CreateIndexBandsNameTsvGist do
  use Ecto.Migration

  def up do
    execute "CREATE INDEX bands_name_tsv_gist ON bands USING gist(name_tsv)"
  end

  def down do
    execute "DROP INDEX bands_name_tsv_gist"
  end
end
