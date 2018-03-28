defmodule Labamba.APITest do

  use Labamba.DataCase
  import Ecto.Query

  alias Labamba.API

  describe "bands" do

    alias Labamba.Model.Band

    @valid_attrs %{description: "some description", name: "some name"}

    def band_fixture(attrs \\ %{}) do
      {:ok, band} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Labamba.Model.create_band()

      band
    end

    @tag :fulltext
    test "where_band_like/2 returns a relevant band" do
      [
        "alpha beta",
        "gamma delta",
        "epsilon zeta"
      ]
      |> Enum.map(fn name -> %{ name: name } end)
      |> Enum.each(&band_fixture/1)

      search_term = ~s(alpha zeta)

      query = from b in Band
      bands = API.where_band_like(query, search_term)
      band_names = bands
                   |> Enum.map(&(&1.name))
                   |> Enum.sort
      assert band_names == ["alpha beta", "epsilon zeta"]
    end

  end

end
