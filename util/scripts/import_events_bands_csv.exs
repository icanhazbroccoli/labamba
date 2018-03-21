alias Labamba.Util.BandEventImporter
require Logger

Logger.info "Cleaning the repo"
BandEventImporter.clear_all()

filename = System.argv()

Logger.info "Loading CSV file #{filename}"

filename
|> Enum.at(0)
|> BandEventImporter.import_csv(?\t, [:event_name, :band_name, :performance_date])

Logger.info "Done importing event bands"