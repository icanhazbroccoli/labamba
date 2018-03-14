# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Labamba.Repo.insert!(%Labamba.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Labamba.EventsBandsSeeder do
  def insert_event_bands({event, _bands}) do
    IO.puts "event_name: #{event}"
  end
end

File.stream!("priv/fixtures/events_bands.csv")
|> CSV.decode!(separator: ?\t)
|> Enum.group_by(fn([k, _]) -> k end, fn([_, v]) -> v end)
|> Enum.each(&Labamba.EventsBandsSeeder.insert_event_bands(&1))
