defmodule Labamba.Util.BandEventImporter do
  @moduledoc false
  use Labamba.Util.CSVImporter, model: Labamba.Model.EventsBands, repo: Labamba.Repo
end
