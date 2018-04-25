defmodule LabambaWeb.API.EventAPIView do
  use LabambaWeb, :view

  alias Labamba.Model.Event

  def render("index.json", %{events: events}) do
    %{
      events: Enum.map(events, &event_json/1)
    }
  end

  # def render("search_by_bands.json", %{event_band_buckets: event_band_buckets}) do
  #   %{
  #     events: Enum.map(event_band_buckets, &event_json/1)
  #   }
  # end

  defp event_json(event) do
    %{
      id: event.id,
      name: event.name,
      date_start: event.date_start,
      date_end: event.date_end,
      descritpion: event.description,
      link: event.link,
      location_place: event.location_place,
      location_country: event.location_country,
      location_lat: event.location_lat,
      location_lon: event.location_lon,
      #band_ids: band_ids,
    }
  end
end
