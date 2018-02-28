defmodule Labamba.Editor.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Editor.Event


  schema "events" do
    field :date_end, :date
    field :date_start, :date
    field :description, :string
    field :location, :string
    field :location_lat, :float
    field :location_lon, :float
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :description, :date_start, :date_end, :location, :location_lat, :location_lon])
    |> validate_required([:name, :description, :date_start, :date_end, :location, :location_lat, :location_lon])
  end
end
