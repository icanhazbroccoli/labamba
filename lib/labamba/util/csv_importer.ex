defmodule Labamba.Util.CSVImporter do

  defmacro __using__([model: model, repo: repo]) do
    quote do

      def import_csv(nil, _, _), do: raise "import_csv/1 is missing a CSV file path"
      def import_csv(filename, separator = ?\t, fields) when is_binary(filename) do
        mapper = _build_mapper(fields)
        File.stream!(filename)
          |> CSV.decode!(separator: separator)
          |> Stream.map(mapper)
          |> Stream.map(fn (attrs) ->
          unquote(Macro.expand(model, __ENV__)).changeset(%unquote(Macro.expand(model, __ENV__)){}, attrs)
          end)
          |> Enum.map(fn changeset ->
            unquote(Macro.expand(repo, __ENV__)).insert(changeset)
          end)
      end
      def import_csv(unknown_arg, _, _), do: "Unknown format of the CSV faile path argument: #{unknown_arg}"

      def clear_all do
        unquote(Macro.expand(repo, __ENV__)).delete_all(unquote(Macro.expand(model, __ENV__)))
      end

      defp _build_mapper(fields) do
        field_mappers = fields
        |> Enum.map(fn(field) ->
          {field, _build_attr_mapper(unquote(Macro.expand(model, __ENV__)).__schema__(:type, field))}
        end)
        |> Enum.into(%{})
        fn (tuple) ->
          tuple
          |> Enum.with_index()
          |> Enum.map(fn {field_v, index} ->
            field_n = fields |> Enum.at(index)
            field_mapper = case field_mappers |> Map.get(field_n) do
              nil -> raise "Unknown field type: #{field_n}"
              v -> v
            end
            {field_n, field_mapper.(field_v)}
          end)
          |> Enum.into(%{})
        end
      end

      defp _build_attr_mapper(:id), do: fn v -> v end
      defp _build_attr_mapper(:string), do: fn v -> v end
      defp _build_attr_mapper(:float) do
        fn v ->
          case v do
            nil -> nil
            "" -> nil
            _ -> String.to_float(v)
          end
        end
      end
      defp _build_attr_mapper(:boolean) do
        fn v ->
          case v do
            nil -> nil
            "" -> nil
            _ -> String.to_integer(v) != 0
          end
        end
      end
      defp _build_attr_mapper(:integer) do
        fn v ->
          case v do
            nil -> nil
            "" -> nil
            _ -> String.to_integer(v)
          end
        end
      end
      defp _build_attr_mapper(:date) do
        fn v ->
          {:ok, parsed_date} = Date.from_iso8601(v)
          parsed_date
        end
      end
      defp _build_attr_mapper(:time) do
        fn v ->
          {:ok, parsed_time} = Time.from_iso8601(v)
          parsed_time
        end
      end
    end
  end

end
