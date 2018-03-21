defmodule TestModel do
  defstruct id: nil, name: nil, number: nil, date: nil
  def __schema__(:fields), do: [:id, :name, :number, :date]
  def __schema__(:primary_key), do: [:id]
  def __schema__(:type, :id), do: :id
  def __schema__(:type, :name), do: :string
  def __schema__(:type, :number), do: :integer
  def __schema__(:type, :date), do: :date
  def __schema__(k, v), do: raise "Undefined mock for #{k}: #{v}"

  def changeset(%TestModel{} = test_model, attrs) do
    attrs
    |> Enum.reduce(test_model, fn ({k, v}, acc) ->
      acc |> Map.put(k, v)
    end)
  end
end

defmodule Labamba.UtilCsvImporterTest do

  alias Labamba.Util.CSVImporter
  use ExUnit.Case, async: true

  defmodule TestCSVImporter do
    use CSVImporter, model: TestModel, repo: Labamba.Test.Repo
  end

  describe "CSVImporter" do

    test "import_csv" do
      changesets = Path.join(__DIR__, "test.csv")
      |> Path.expand
      |> TestCSVImporter.import_csv(?\t, [:id, :name, :number, :date])

      changesets
      |> Enum.each(fn _changeset = %TestModel{} ->
        assert true
      end)
    end

  end
end
