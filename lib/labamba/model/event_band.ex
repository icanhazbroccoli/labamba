defmodule Labamba.Model.EventBand do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Model
  alias Labamba.Model.{Event, Band, EventBand}

  def __schema__(:type, :band_name), do: :string
  def __schema__(:type, :event_name), do: :string

  @primary_key false
  schema "events_bands" do
    belongs_to :event, Event
    belongs_to :band, Band
    field :performance_date, :date
  end

  def changeset(%EventBand{} = event_band, %{band_name: band_name, event_name: event_name} = attrs) do
    expanded_attrs = attrs
    |> Map.drop([:band_name, :event_name])
    |> Map.put(:band, Model.find_band!(name: band_name))
    |> Map.put(:event, Model.find_event!(name: event_name))

    changeset(event_band, expanded_attrs)
  end

  def changeset(%EventBand{} = event_band, %{event: event, band: band} = attrs) do
    event_band
    |> cast(attrs, [:performance_date])
    |> put_assoc(:event, event)
    |> put_assoc(:band, band)
    |> validate_required([:performance_date]) #, :event_id, :band_id])
  end

  def changeset(%EventBand{} = event_band, %{event_id: event_id, band_id: band_id} = attrs) do
    event_band
    |> cast(attrs, [:performance_date, :event_id, :band_id])
    |> unique_constraint(:event_id_band_id)
    |> validate_required([:performance_date, :event_id, :band_id])
  end
end
