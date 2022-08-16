defmodule Iris.Rigging.BusinessUnit do
  @moduledoc """
  This module represents a *BusinessUnit* in Cordage.

  Attributes:
    * id
    * active
    * name
    * code
    * description
    * social_reason
    * address
    * timezone
    * organization_id
    * responsible_id
  """

  import Iris.Response
  import Iris.Request

  @enforce_keys [
    :active,
    :name,
    :code,
    :description,
    :social_reason,
    :address,
    :timezone,
    :organization_id,
    :responsible_id
  ]

  defstruct @enforce_keys

  @url "/api/v1/business_units/"

  @doc """
  Gets a *Business Unit* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the business unit they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce by *Rigging*.

  Examples

      iex> BusinessUnit.get("my valid token", "my id")
      iex> {:ok, %Iris.Rigging.BusinessUnit{}}

      iex> BusinessUnit.get("my valid token", "invalid id")
      iex> {:error, %Iris.Error.NotFoundError}

      iex> BusinessUnit.get("my invalid token", "my id")
      iex> {:error, %Iris.Error.UnauthorizedError}
  """
  @spec get(user_token :: String.t(), id :: String.t()) :: {:ok, %__MODULE__{}}
  | {:error, %Iris.Error.NotFoundError{}}
  | {:error, %Iris.Error.UnauthorizedError{}}
  def get(user_token, id) when is_binary(id) do
    request(:rigging, @url <> id, user_token)
    |> parse
    |> return
  end

  @doc """
  Gets a *Business Unit* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the business unit they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> BusinessUnit.get!("my valid token", "my id")
      iex> %Iris.Rigging.BusinessUnit{}

      iex> BusinessUnit.get!("my valid token", "invalid id")
      iex> ** Iris.Error.NotFoundError

      iex> BusinessUnit.get!("my invalid token", "my id")
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec get!(user_token :: String.t(), id :: String.t()) :: %__MODULE__{}
  def get!(user_token, id) when is_binary(id) do
    return! get(user_token, id)
  end

  def parse({:error, error}), do: {:error, error}
  def parse({:ok, body}), do: {:ok, struct(__MODULE__, body)}
end
