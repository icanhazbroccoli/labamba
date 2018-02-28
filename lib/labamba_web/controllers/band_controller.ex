defmodule LabambaWeb.BandController do
  use LabambaWeb, :controller

  alias Labamba.Editor
  alias Labamba.Editor.Band

  def index(conn, _params) do
    bands = Editor.list_bands()
    render(conn, "index.html", bands: bands)
  end

  def new(conn, _params) do
    changeset = Editor.change_band(%Band{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"band" => band_params}) do
    case Editor.create_band(band_params) do
      {:ok, band} ->
        conn
        |> put_flash(:info, "Band created successfully.")
        |> redirect(to: band_path(conn, :show, band))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    band = Editor.get_band!(id)
    render(conn, "show.html", band: band)
  end

  def edit(conn, %{"id" => id}) do
    band = Editor.get_band!(id)
    changeset = Editor.change_band(band)
    render(conn, "edit.html", band: band, changeset: changeset)
  end

  def update(conn, %{"id" => id, "band" => band_params}) do
    band = Editor.get_band!(id)

    case Editor.update_band(band, band_params) do
      {:ok, band} ->
        conn
        |> put_flash(:info, "Band updated successfully.")
        |> redirect(to: band_path(conn, :show, band))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", band: band, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    band = Editor.get_band!(id)
    {:ok, _band} = Editor.delete_band(band)

    conn
    |> put_flash(:info, "Band deleted successfully.")
    |> redirect(to: band_path(conn, :index))
  end
end
