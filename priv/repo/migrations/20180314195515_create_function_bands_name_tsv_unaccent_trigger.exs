defmodule Labamba.Repo.Migrations.CreateFunctionBandsNameTsvUnaccentTrigger do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE bands ADD COLUMN name_tsv tsvector;"
    execute """
    CREATE FUNCTION F_bands_name_tsv_unaccent_trigger() RETURNS trigger AS $$
    begin
      new.name_tsv :=
        to_tsvector('pg_catalog.english', unaccent(new.name));
      return new;
    end
    $$ LANGUAGE plpgsql;
    """
  end

  def down do
    execute "ALTER TABLE bands DROP COLUMN name_tsv;"
    execute "DROP FUNCTION F_bands_name_tsv_unaccent_trigger;"
  end
end
