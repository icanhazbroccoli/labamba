# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Labamba.Repo.insert!(%Labamba.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Labamba.EventsBandsSeeder do

  alias Labamba.Repo
  alias Labamba.Model.{Event, Band}

  def find_or_create_event_by(attrs) do
    res = case v = Repo.get_by(Event, attrs) do
      nil ->
        {:ok, new} = Repo.insert(Event.changeset(%Event{}, attrs |> Enum.into(%{})))
        new
      _ -> v |> Repo.preload(:bands)
    end
    IO.inspect "res: #{res}"
    res
  end

  def find_or_create_band_by(attrs) do
    case v = Repo.get_by(Band, attrs) do
      nil ->
        {:ok, new} = Repo.insert(Band.changeset(%Band{}, attrs |> Enum.into(%{})))
        new
      _ -> v |> Repo.preload(:events)
    end
  end

  def insert_event_bands({event_name, band_names}) do
    event = find_or_create_event_by(name: event_name)
    IO.inspect(event)
    bands = band_names
    |> Enum.map(fn band_name ->
      find_or_create_band_by(name: band_name)
    end)
    event_change = Ecto.Changeset.change(event)
    event_with_bands = Ecto.Changeset.put_assoc(event_change, :bands, bands)
    event = Repo.update!(event_with_bands)
    IO.inspect event
  end

  def clear_all do
    Repo.delete_all(Event)
    Repo.delete_all(Band)
  end

end

Labamba.EventsBandsSeeder.clear_all()

File.stream!("priv/fixtures/events_bands.csv")
|> CSV.decode!(separator: ?\t)
|> Enum.group_by(fn([k, _]) -> k end, fn([_, v]) -> v end)
|> Enum.each(&Labamba.EventsBandsSeeder.insert_event_bands(&1))
