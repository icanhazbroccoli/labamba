defmodule Labamba.Repo.Migrations.CreateBands do
  use Ecto.Migration

  def change do
    create table(:bands) do

      add :name, :string
      add :pic_url, :string
      add :band_website, :string
      add :description, :text

      timestamps()
    end

    create index(:bands, [:name])
  end
end
