defmodule Iris.Adapters.AppendItems do
  defguard is_valid_input(token, list, module, key)
           when is_list(list) and is_atom(module) and is_atom(key) and is_binary(token)

  def from_list(token, list, module, key) when is_valid_input(token, list, module, key) do
    ids = Enum.map(list, &Map.get(&1, key))

    with {:ok, items} <- module.all(token, ids) do
      key_without_sufix =
        String.slice(Atom.to_string(key), 0..-4)
        |> String.to_atom()

      {:ok,
       for item <- items, entry <- list do
         Map.put(entry, key_without_sufix, item)
         |> Map.delete(key)
       end}
    end
  end

  def from_list!(token, list, module, key) when is_valid_input(token, list, module, key) do
    ids = Enum.map(list, &Map.get(&1, key))

    items = module.all!(token, ids)

    key_without_sufix =
      String.slice(Atom.to_string(key), 0..-4)
      |> String.to_atom()

    for item <- items, entry <- list do
      Map.put(entry, key_without_sufix, item)
      |> Map.delete(key)
    end
  end
end
