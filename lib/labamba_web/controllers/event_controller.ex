defmodule LabambaWeb.EventController do
  use LabambaWeb, :controller

  alias Labamba.Model
  alias Labamba.Model.Event
  alias Labamba.Repo

  def index(conn, _params) do
    events = Model.list_events()
    render(conn, "index.html", events: events)
  end

  def new(conn, _params) do
    changeset = Model.change_event(%Event{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"event" => event_params}) do
    case Model.create_event(event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event created successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    event = Model.get_event!(id)
    render(conn, "show.html", event: event)
  end

  def edit(conn, %{"id" => id}) do
    event = Model.get_event!(id) |> Repo.preload(:bands)
    changeset = Model.change_event(event)
    render(conn, "edit.html", event: event, changeset: changeset)
  end

  def update(conn, %{"id" => id, "event" => event_params}) do
    event = Model.get_event!(id) |> Repo.preload(:bands)

    case Model.update_event(event, event_params) do
      {:ok, event} ->
        conn
        |> put_flash(:info, "Event updated successfully.")
        |> redirect(to: event_path(conn, :show, event))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", event: event, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    event = Model.get_event!(id)
    {:ok, _event} = Model.delete_event(event)

    conn
    |> put_flash(:info, "Event deleted successfully.")
    |> redirect(to: event_path(conn, :index))
  end
end
