defmodule Labamba.Util.EventsCsvImporter do

  alias Labamba.Test.Repo
  alias Labamba.Model.Event

  use Labamba.Util.CSVImporter, Event

end

System.argv()
  |> Enum.at(0)
  |> Labamba.Util.EventsCsvImporter.import_csv()
