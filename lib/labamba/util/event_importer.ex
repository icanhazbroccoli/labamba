defmodule Labamba.Util.EventImporter do
  @moduledoc false
  use Labamba.Util.CSVImporter, model: Labamba.Model.Event, repo: Labamba.Repo
end