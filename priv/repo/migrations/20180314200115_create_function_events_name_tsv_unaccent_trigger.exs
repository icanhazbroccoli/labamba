defmodule Labamba.Repo.Migrations.CreateFunctionEventsNameTsvUnaccentTrigger do
  use Ecto.Migration

  def up do
    execute "ALTER TABLE events ADD COLUMN name_tsv tsvector;"
    execute """
    CREATE FUNCTION F_events_name_tsv_unaccent_trigger() RETURNS trigger AS $$
    begin
      new.name_tsv :=
        to_tsvector('pg_catalog.english', unaccent(new.name));
      return new;
    end
    $$ LANGUAGE plpgsql;
    """
  end

  def down do
    execute "ALTER TABLE events DROP COLUMN name_tsv;"
    execute "DROP FUNCTION F_events_name_tsv_unaccent_trigger;"
  end
end
