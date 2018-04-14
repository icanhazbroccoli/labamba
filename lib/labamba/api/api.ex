defmodule Labamba.API do

  import Ecto.Query, warn: false
  alias Labamba.Repo
  alias Labamba.Model.{Band, Event, EventBand}

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
    |> Repo.all
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
          _ -> [bucket | eb.band_id]
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
