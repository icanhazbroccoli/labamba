defmodule Labamba.API do

  import Ecto.Query, warn: false
  alias Labamba.Repo
  alias Labamba.Model.{Band, Event}

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

  defp normalize(search_string) do
    search_string
    |> String.downcase
    |> String.replace(~r/\n/, " ")
    |> String.replace(~r/\t/, " ")
    |> String.replace(~r/\s{2,}/, " ")
    |> String.trim
  end

end
