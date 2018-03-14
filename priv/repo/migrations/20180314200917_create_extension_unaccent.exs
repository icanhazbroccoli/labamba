defmodule Labamba.Repo.Migrations.CreateExtensionUnaccent do
  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION unaccent;"
  end

  def down do
    execute "DROP EXTENSION unaccent;"
  end
end
