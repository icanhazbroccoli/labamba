defmodule Labamba.Editor.Band do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Editor.Band


  schema "bands" do
    field :description, :string
    field :indexed_name, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Band{} = band, attrs) do
    band
    |> cast(attrs, [:name, :indexed_name, :description])
    |> validate_required([:name, :indexed_name, :description])
  end
end
