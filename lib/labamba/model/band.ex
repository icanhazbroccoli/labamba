defmodule Labamba.Model.Band do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Model.Band

  schema "bands" do
    field :name, :string
    field :pic_url, :string
    field :band_website, :string
    field :description, :string
    field :youtube

    many_to_many :events, Labamba.Model.Event, join_through: "events_bands"

    timestamps()
  end

  @doc false
  def changeset(%Band{} = band, attrs) do
    band
    |> cast(attrs, [:name, :pic_url, :band_website, :description, :youtube])
    |> validate_required([:name])
  end

end
