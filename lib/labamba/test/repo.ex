defmodule Labamba.Test.Repo do

  def delete_all(_model) do
    true
  end

  def insert_all(_model, entries) do
    entries
  end

  def insert(entry) do
    entry
  end
  
end
