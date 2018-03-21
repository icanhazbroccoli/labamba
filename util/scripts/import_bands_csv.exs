alias Labamba.Util.BandImporter
require Logger

Logger.info "Cleaning the repo"
BandImporter.clear_all()

filename = System.argv()

Logger.info "Loading CSV file #{filename}"

filename
|> Enum.at(0)
|> BandImporter.import_csv(?\t, [:name, :description, :band_website, :pic_url, :youtube])

Logger.info "Done importing bands"