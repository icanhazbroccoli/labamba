defmodule Labamba.Model.Band do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Model.Band

  schema "bands" do
    field :description, :string
    field :name, :string

    many_to_many :events, Labamba.Model.Event, join_through: "events_bands"

    timestamps()
  end

  @doc false
  def changeset(%Band{} = band, attrs) do
    band
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end

end
