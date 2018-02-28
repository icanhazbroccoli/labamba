defmodule LabambaWeb.PageController do
  use LabambaWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
