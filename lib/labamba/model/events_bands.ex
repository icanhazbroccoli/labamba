defmodule Labamba.Model.EventsBands do
  use Ecto.Schema
  import Ecto.Changeset
  alias Labamba.Model.{Event, Band, EventsBands}

  schema "events_bands" do
    belongs_to :event, Event
    belongs_to :band, Band
    field :performance_date, :date

    timestamps()
  end

  @doc false
  def changeset(%EventsBands{} = events_bands, attrs) do
    events_bands
    |> cast(attrs, [:event, :band, :performance_date])
    |> validate_required([:event, :band, :performance_date])
  end
end
