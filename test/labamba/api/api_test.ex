defmodule Labamba.APITest do

  use Labamba.DataCase
  import Ecto.Query

  alias Labamba.API

  describe "bands" do

    alias Labamba.Model.Band

    @valid_attrs %{description: "some description", name: "some name"}

    def band_fixture_with_defaults(attrs \\ %{}) do
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
      |> Enum.each(&band_fixture_with_defaults/1)

      search_term = ~s(alpha zeta)

      query = from b in Band
      bands = API.where_band_like(query, search_term)
      band_names = bands
                   |> Enum.map(&(&1.name))
                   |> Enum.sort
      assert band_names == ["alpha beta", "epsilon zeta"]
    end

  end

  describe "events_bands" do

    alias Labamba.Model.{Band, Event, EventBand}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Labamba.Model.create_event()
      event
    end

    def band_fixture(attrs \\ %{}) do
      {:ok, band} =
        attrs
        |> Labamba.Model.create_band()
      band
    end

    def event_band_fixture(attrs \\ %{}) do
      {:ok, event_band} =
        attrs
        |> Labamba.Model.create_event_band()
      event_band
    end

    test "event_ids_by_band_ids" do
      bands = [
        %{ name: "name1", description: "description1" },
        %{ name: "name2", description: "description2" },
        %{ name: "name3", description: "description3" },
        %{ name: "name4", description: "description4" }
      ] |> Enum.map(&band_fixture/1)

      events = [
        %{ name: "event1", date_start: ~D(2018-01-01), date_end: ~D(2018-01-02), link: "http://link1" },
        %{ name: "event2", date_start: ~D(2018-02-02), date_end: ~D(2018-02-03), link: "http://link2" },
        %{ name: "event3", date_start: ~D(2018-03-03), date_end: ~D(2018-03-04), link: "http://link3" },
      ] |> Enum.map(&event_fixture/1)

      event_bands = [
        %{ event_id: Enum.at(events, 0).id, band_id: Enum.at(bands, 0).id, performance_date: ~D(2018-01-01) },
#        %{ event_id: Enum.at(events, 0).id, band_id: Enum.at(bands, 0).id, performance_date: ~D(2018-01-01) },
        %{ event_id: Enum.at(events, 0).id, band_id: Enum.at(bands, 3).id, performance_date: ~D(2018-01-01) },
        %{ event_id: Enum.at(events, 1).id, band_id: Enum.at(bands, 0).id, performance_date: ~D(2018-02-02) },
        %{ event_id: Enum.at(events, 1).id, band_id: Enum.at(bands, 2).id, performance_date: ~D(2018-02-02) },
        %{ event_id: Enum.at(events, 2).id, band_id: Enum.at(bands, 1).id, performance_date: ~D(2018-03-03) },
      ] |> Enum.map(&event_band_fixture/1)

      data = API.event_ids_by_band_ids([1, 2, 3])
      IO.inspect data
    end

  end

end
