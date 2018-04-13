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

  def events_by_bands(band_ids) when is_list(band_ids) do
    # TODO
  end

  def event_ids_by_band_ids(band_ids) do
    EventBand
    |> where([eb], eb.band_id in ^band_ids)
    |> Repo.all
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
