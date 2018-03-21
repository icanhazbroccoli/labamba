defmodule BandImporter do
  @moduledoc false
  use Labamba.Util.CSVImporter, model: Labamba.Model.Band, repo: Labamba.Repo
end
