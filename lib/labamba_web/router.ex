defmodule LabambaWeb.Router do
  use LabambaWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LabambaWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/editor", LabambaWeb do
    pipe_through :browser

    resources "/bands", BandController
    resources "/events", EventController
  end

  # Other scopes may use custom stacks.
   scope "/api", LabambaWeb do
     pipe_through :api

     get "/bands", API.BandAPIController, :index
     get "/events", API.EventAPIController, :index
     #get "/events_by_bands", API.EventAPIController, :search_by_bands
   end
end
