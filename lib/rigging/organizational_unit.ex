defmodule Iris.Rigging.OrganizationalUnit do
  import Iris.Response
  import Iris.Request

  @enforce_keys ~w[
    name
    code
    description
    level
    parent_id
    organization_id
    responsible_id
  ]a

  defstruct @enforce_keys

  @url "/api/v1/organizational_units/"

  def get(user_token, id) when is_binary(id) do
    request(:rigging, @url <> id, user_token)
    |> parse()
    |> return()
  end

  @spec get!(binary, binary) :: any
  def get!(user_token, id) when is_binary(id) do
    return! get(user_token, id)
  end

  defp parse({:error, error}), do: {:error, error}
  defp parse({:ok, body}) do
    {:ok, struct(__MODULE__, body)}
  end
end
