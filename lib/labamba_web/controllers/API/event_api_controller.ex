defmodule LabambaWeb.API.EventAPIController do

  use LabambaWeb, :controller

  alias Labamba.API
  alias Labamba.Model.{Event, EventBand}

  def index(conn, params) do
    events = API.search_events(params)
    render conn, "index.json", events: events
  end

  # def search_by_bands(conn, params = %{"band_ids" => band_ids}) when is_binary(band_ids) do
  #   search_by_bands(
  #     conn,
  #     Map.put(
  #       params,
  #       "band_ids",
  #       String.split(band_ids, ",") |> Enum.map(&String.to_integer/1)
  #     )
  #   )
  # end

  # def search_by_bands(conn, %{"band_ids" => band_ids}) when is_list(band_ids) do
  #   event_band_buckets = API.event_band_buckets_by_band_ids(band_ids)
  #   IO.inspect event_band_buckets
  #   render conn, "search_by_bands.json", event_band_buckets: event_band_buckets
  # end

end
