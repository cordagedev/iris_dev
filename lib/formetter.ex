defmodule Iris.Formatter do
  def format_list(results) do
    # this will return two lists:
    # the first one will be all *found* items
    # the second one will be the ones that returned an error
    Enum.split_with(results, fn {status, _data} -> :ok == status end)
    |> extract_data()
  end

  def extract_data({oks, _errors = []}) do
    {:ok, Enum.map(oks, fn {_status, data} -> data end)}
  end

  def extract_data({_oks, _errors}), do: {:error, :not_found}
end
