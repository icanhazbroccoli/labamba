defmodule LabambaWeb.API.BandAPIController do

  use LabambaWeb, :controller

  alias Labamba.API
  alias Labamba.Model.Band

  def index(conn, params) do
    bands = API.search_bands(params)
    render conn, "index.json", bands: bands
  end

end
