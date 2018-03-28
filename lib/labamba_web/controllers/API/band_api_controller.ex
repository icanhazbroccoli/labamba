defmodule LabambaWeb.API.BandAPIController do

  use LabambaWeb, :controller

  alias Labamba.API
  alias Labamba.Model.Band

  def search(conn, %{"like" => like}) do
    bands = API.where_band_like(like)
    render conn, "search.json", bands: bands
  end

end
