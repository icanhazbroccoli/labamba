alias Labamba.Util.EventImporter
require Logger

Logger.info "Cleaning the repo"
EventImporter.clear_all()

filename = System.argv()

Logger.info "Loading CSV file #{filename}"

filename
  |> Enum.at(0)
  |> EventImporter.import_csv(?\t, [:name, :date_start, :date_end, :link, :location_place, :location_country, :location_lat, :location_lon])

Logger.info "Done importing events"