defmodule Labamba.Repo.Migrations.CreateTriggerBandsNameTsvUnaccentTrigger do
  use Ecto.Migration

  def up do
    execute """
    CREATE TRIGGER T_bands_name_tsv_unaccent_trigger BEFORE INSERT OR UPDATE
    ON bands FOR EACH ROW EXECUTE PROCEDURE F_bands_name_tsv_unaccent_trigger();
    """
  end

  def down do
    execute "DROP TRIGGER T_bands_name_tsv_unaccent_trigger on bands"
  end
end
