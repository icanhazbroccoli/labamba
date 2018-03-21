defmodule Labamba.Model.EventsBands do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Model
  alias Labamba.Model.{Event, Band, EventsBands}

  @primary_key false

  def __schema__(:type, :band_name), do: :string
  def __schema__(:type, :event_name), do: :string

  schema "events_bands" do
    belongs_to :event, Event
    belongs_to :band, Band
    field :performance_date, :date
  end

  @doc false

  def changeset(%EventsBands{} = events_bands, %{band_name: band_name, event_name: event_name} = attrs) do
    expanded_attrs = attrs
    |> Map.drop([:band_name, :event_name])
    |> Map.put(:band_id, Model.find_band!(name: band_name).id)
    |> Map.put(:event_id, Model.find_event!(name: event_name).id)

    changeset(events_bands, expanded_attrs)
  end

  def changeset(%EventsBands{} = events_bands, attrs) do
    events_bands
    |> cast(attrs, [:performance_date, :event_id, :band_id])
    |> validate_required([:performance_date, :event_id, :band_id])
  end
end
