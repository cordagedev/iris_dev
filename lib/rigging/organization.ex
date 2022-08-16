defmodule Iris.Rigging.Organization do
  @moduledoc """
  This module represents the *Organization* in Cordage.

  Attributes:
    * id
    * name
    * display_name
    * auth0_id
    * responsible_id
    * main_business_unit_id
  """

  import Iris.Response
  import Iris.Request

  @enforce_keys [
    :name,
    :display_name,
    :auth0_id,
    :responsible_id,
    :main_business_unit_id
  ]

  defstruct @enforce_keys

  @url "/api/v1/organizations/"

  @spec get(binary, binary) :: {:ok, map()} | {:error, String.t()}
  def get(user_token, id) when is_binary(id) do
    request(:rigging, @url <> id, user_token)
    |> parse
    |> return
  end

  @spec get!(binary, binary) :: any
  def get!(user_token, id) when is_binary(id) do
    return! get(user_token, id)
  end

  def parse({:error, error}), do: {:error, error}

  def parse({:ok, body}), do: {:ok, struct(__MODULE__, body)}
end
