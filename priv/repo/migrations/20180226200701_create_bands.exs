defmodule Labamba.Repo.Migrations.CreateBands do
  use Ecto.Migration

  def change do
    create table(:bands) do
      add :name, :string
      add :indexed_name, :string
      add :description, :text

      timestamps()
    end

  end
end
