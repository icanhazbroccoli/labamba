defmodule Labamba.Repo.Migrations.CreateTriggerEventsNameTsvUnaccentTrigger do
  use Ecto.Migration

  def up do
    execute """
    CREATE TRIGGER T_events_name_tsv_unaccent_trigger BEFORE INSERT OR UPDATE
    ON events FOR EACH ROW EXECUTE PROCEDURE F_events_name_tsv_unaccent_trigger();
    """
  end

  def down do
    execute "DROP TRIGGER T_bands_name_tsv_unaccent_trigger on events"
  end
end
