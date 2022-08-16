defmodule Iris.Rigging.User do
  import Iris.Response
  import Iris.Request

  @enforce_keys ~w[
    first_name
    middle_name
    last_name
    email
    timezone
    auth0_id
    type
    status
    language
    organization_id
    organizational_unit_id
    job_title_id
  ]a

  defstruct @enforce_keys

  @url "/api/v1/users/"

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
