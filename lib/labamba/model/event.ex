defmodule Labamba.Model.Event do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Model.Event

  schema "events" do
    field :name, :string
    field :date_start, :date
    field :date_end, :date
    field :description, :string
    field :link, :string
    field :location_place, :string
    field :location_country, :string
    field :location_lat, :float
    field :location_lon, :float

    many_to_many :bands, Labamba.Model.Band, join_through: "events_bands"

    timestamps()
  end

  @doc false
  def changeset(%Event{} = event, attrs) do
    event
    |> cast(attrs, [:name, :date_start, :date_end, :description, :link, :location_place, :location_country, :location_lat, :location_lon])
    |> unique_constraint(:name)
    |> put_assoc(:bands, parse_bands(attrs))
    |> validate_required([:name, :date_start, :date_end, :link])
  end

  defp parse_bands(params) do
    (params["bands"] || "")
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(& &1 == "")
    |> Enum.map(&get_or_insert_band/1)
  end

  defp get_or_insert_band(name) do
    Labamba.Repo.get_by(Labamba.Model.Band, name: name) ||
      Labamba.Repo.insert!(Labamba.Model.Band, %Labamba.Model.Band{name: name})
  end
end
