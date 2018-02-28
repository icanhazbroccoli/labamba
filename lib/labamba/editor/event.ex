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

    many_to_many :bands, Labamba.Editor.Band, join_through: "events_bands"

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :description, :date_start, :date_end, :location, :location_lat, :location_lon])
    |> put_assoc(:bands, parse_bands(attrs))
    |> validate_required([:name, :description, :date_start, :date_end, :location, :location_lat, :location_lon])
  end

  defp parse_bands(params) do
    (params["bands"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_band/1)
  end

  defp get_or_insert_band(name) do
    Labamba.Repo.get_by(Labamba.Editor.Band, name: name) ||
      Labamba.Repo.insert!(Labamba.Editor.Band, %Labamba.Editor.Band{name: name})
  end
end
