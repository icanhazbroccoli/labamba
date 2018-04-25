defmodule Labamba.API do

  import Ecto.Query, warn: false
  alias Labamba.Repo
  alias Labamba.Model.{Band, Event, EventBand}

  def search_bands(params) do
    query = from b in Band
    do_search_bands(query, params)
    |> Repo.all
  end

  defp do_search_bands(query, params = %{"like" => like}) do
    do_search_bands(
      where_band_like(query, like),
      Map.delete(params, "like")
    )
  end
  defp do_search_bands(query, _params), do: query

  def where_band_like(search_term) do
    q = from b in Band
    where_band_like(q, search_term)
  end
  def where_band_like(query, search_term) do
    tsv_query = search_term
                |> normalize
                |> String.split(~r/\s+/)
                |> Enum.map(fn chunk -> "#{chunk}:*" end)
                |> Enum.join(" | ")
    (from b in query,
          where: fragment("? @@ to_tsquery(unaccent(?))", b.name_tsv, ^tsv_query))
  end

  def search_events(params) do
    query = from e in Event
    do_search_events(query, params)
    |> Repo.all
  end

  defp do_search_events(query, params = %{"band_ids" => band_ids}) when is_binary(band_ids) do
    do_search_events(
      query,
      Map.put(
        params,
        "band_ids",
        String.split(band_ids, ",") |> Enum.map(&String.to_integer/1)
      )
    )
  end
  defp do_search_events(query, params = %{"band_ids" => band_ids}) do
    do_search_bands(
      query |> where_band_id_in(band_ids),
      Map.delete(params, "band_ids")
    )
  end
  defp do_search_events(query, params = %{"retrospect" => retrospect}), do: query
  defp do_search_events(query, _params) do
    query
    |> where([e], e.date_end >= ^Date.utc_today())
  end

  defp where_band_id_in(query, band_ids) do
    event_ids = EventBand
    |> where([eb], eb.band_id in ^band_ids)
    |> select([eb], eb.event_id)
    |> Repo.all
    |> IO.inspect
    query
    |> where([e], e.id in ^event_ids)
  end

  def event_band_buckets_by_band_ids(band_ids) when is_list(band_ids) do
    event_band_id_buckets = event_band_id_buckets_by_band_ids(band_ids)
    case Map.keys(event_band_id_buckets) do
      [] -> []
      ks -> Event |> where([e], e.id in ^ks) |> Repo.all |> Enum.map(fn ev ->
        %{event: ev, band_ids: Map.get(event_band_id_buckets, ev.id)}
      end)
    end
  end

  def event_band_id_buckets_by_band_ids(band_ids) do
    EventBand
    |> where([eb], eb.band_id in ^band_ids)
    |> where([eb], eb.performance_date >= ^Date.utc_today())
    |> Repo.all
    |> Enum.reduce(%{}, fn (eb, acc) ->
      {_, acc} = Map.get_and_update(acc, eb.event_id, fn bucket ->
        new_bucket = case bucket do
          nil -> [eb.band_id]
          _ -> [eb.band_id | bucket]
        end
        {bucket, new_bucket}
      end)
      acc
    end)
  end

  defp normalize(search_string) do
    search_string
    |> String.downcase
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
  end

end
