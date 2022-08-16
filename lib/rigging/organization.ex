defmodule Iris.Rigging.Organization do
  use Iris.Response
  use Iris.Request

  import Iris.Tools

  @url "/api/v1/organizations/"

  @spec get(binary, binary) :: {:ok, map()} | {:error, String.t()}
  def get(user_token, id) when is_binary(id) do
    request(:rigging, @url <> id, user_token)
    |> parse(:organization)
    |> return
  end

  @spec get!(binary, binary) :: any
  def get!(user_token, id) when is_binary(id) do
    return! get(user_token, id)
  end
end
