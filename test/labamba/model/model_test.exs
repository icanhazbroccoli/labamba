defmodule Labamba.ModelTest do
  use Labamba.DataCase
  import Ecto.Query

  alias Labamba.Model

  describe "bands" do
    alias Labamba.Model.Band

    @valid_attrs %{description: "some description", name: "some name"}
    @update_attrs %{description: "some updated description", name: "some updated name"}
    @invalid_attrs %{description: nil, name: nil}

    def band_fixture(attrs \\ %{}) do
      {:ok, band} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_band()
      band
    end

    test "list_bands/0 returns all bands" do
      band = band_fixture()
      assert Model.list_bands() == [band]
    end

    test "get_band!/1 returns the band with given id" do
      band = band_fixture()
      assert Model.get_band!(band.id) == band
    end

    test "create_band/1 with valid data creates a band" do
      assert {:ok, %Band{} = band} = Model.create_band(@valid_attrs)
      assert band.description == "some description"
      assert band.name == "some name"
    end

    test "create_band/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_band(@invalid_attrs)
    end

    test "update_band/2 with valid data updates the band" do
      band = band_fixture()
      assert {:ok, band} = Model.update_band(band, @update_attrs)
      assert %Band{} = band
      assert band.description == "some updated description"
      assert band.name == "some updated name"
    end

    test "update_band/2 with invalid data returns error changeset" do
      band = band_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_band(band, @invalid_attrs)
      assert band == Model.get_band!(band.id)
    end

    test "delete_band/1 deletes the band" do
      band = band_fixture()
      assert {:ok, %Band{}} = Model.delete_band(band)
      assert_raise Ecto.NoResultsError, fn -> Model.get_band!(band.id) end
    end

    test "change_band/1 returns a band changeset" do
      band = band_fixture()
      assert %Ecto.Changeset{} = Model.change_band(band)
    end

  end

  describe "events" do
    alias Labamba.Model.Event

    @valid_attrs %{date_end: ~D[2010-04-17], date_start: ~D[2010-04-17], description: "some description", location_place: "some location", location_country: "some country", location_lat: 120.5, location_lon: 120.5, name: "some name", link: "some link"}
    @update_attrs %{date_end: ~D[2011-05-18], date_start: ~D[2011-05-18], description: "some updated description", location_place: "some updated location", location_country: "some updated country", location_lat: 456.7, location_lon: 456.7, name: "some updated name", link: "some updated link"}
    @invalid_attrs %{date_end: nil, date_start: nil, description: nil, location_place: nil, location_country: nil, location_lat: nil, location_lon: nil, name: nil, link: nil}

    def event_fixture(attrs \\ %{}) do
      {:ok, event} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Model.create_event()

      event
    end

    test "list_events/0 returns all events" do
      event = event_fixture()
      assert Model.list_events() |> Repo.preload(:bands) == [event]
    end

    test "get_event!/1 returns the event with given id" do
      event = event_fixture()
      assert Model.get_event!(event.id) |> Repo.preload(:bands) == event
    end

    test "create_event/1 with valid data creates a event" do
      assert {:ok, %Event{} = event} = Model.create_event(@valid_attrs)
      assert event.date_end == ~D[2010-04-17]
      assert event.date_start == ~D[2010-04-17]
      assert event.description == "some description"
      assert event.location_place == "some location"
      assert event.location_country == "some country"
      assert event.location_lat == 120.5
      assert event.location_lon == 120.5
      assert event.name == "some name"
      assert event.link == "some link"
    end

    test "create_event/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Model.create_event(@invalid_attrs)
    end

    test "update_event/2 with valid data updates the event" do
      event = event_fixture()
      assert {:ok, event} = Model.update_event(event, @update_attrs)
      assert %Event{} = event
      assert event.date_end == ~D[2011-05-18]
      assert event.date_start == ~D[2011-05-18]
      assert event.description == "some updated description"
      assert event.location_place == "some updated location"
      assert event.location_country == "some updated country"
      assert event.location_lat == 456.7
      assert event.location_lon == 456.7
      assert event.name == "some updated name"
      assert event.link == "some updated link"
    end

    test "update_event/2 with invalid data returns error changeset" do
      event = event_fixture()
      assert {:error, %Ecto.Changeset{}} = Model.update_event(event, @invalid_attrs)
      assert event == Model.get_event!(event.id) |> Repo.preload(:bands)
    end

    test "delete_event/1 deletes the event" do
      event = event_fixture()
      assert {:ok, %Event{}} = Model.delete_event(event)
      assert_raise Ecto.NoResultsError, fn -> Model.get_event!(event.id) end
    end

    test "change_event/1 returns a event changeset" do
      event = event_fixture()
      assert %Ecto.Changeset{} = Model.change_event(event)
    end
  end
end
