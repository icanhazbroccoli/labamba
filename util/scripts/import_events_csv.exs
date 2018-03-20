System.argv()
  |> Enum.at(0)
  |> Labamba.Util.EventImporter.import_csv(?\t, [:name, :date_start, :date_end, :link, :location_place, :location_country, :location_lat, :location_lon])
  |> Enum.each(&IO.inspect/1)
#  |> IO.inspect
