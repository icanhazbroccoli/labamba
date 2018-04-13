defmodule Labamba.Util.BandEventImporter do
  @moduledoc false
  use Labamba.Util.CSVImporter, model: Labamba.Model.EventBand, repo: Labamba.Repo
end
