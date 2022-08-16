defmodule Iris.Rigging.User do
  @moduledoc """
  This module represents a *User* in Cordage.

  Attributes:
    * first_name
    * middle_name
    * last_name
    * email
    * timezone
    * auth0_id
    * type
    * status
    * language
    * organization_id
    * organizational_unit_id
    * job_title_id
  """

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

  @doc """
  Gets a *User* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the user they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization logic will be enforce
  > by *Rigging*.

  ## Examples

       iex> User.get("my valid token", "my id")
       iex> {:ok, %Iris.Rigging.User{}}

       iex> User.get("my valid token", "invalid id")
       iex> {:error, %Iris.Error.NotFoundError{}}
  """
  @spec get(user_token :: String.t(), id :: String.t()) ::
          {:ok, %__MODULE__{}}
          | {:error, %Iris.Error.NotFoundError{}}
          | {:error, %Iris.Error.UnauthorizedError{}}
  def get(user_token, id) when is_binary(id) do
    request(:rigging, @url <> id, user_token)
    |> parse()
    |> return()
  end

  @doc """
  Gets a *User* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the user they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  ## Examples

      iex> User.get!("my valid token", "my id")
      iex> %Iris.Rigging.User{}
      
      iex> User.get!("my valid token", "invalid id")
      ** (Iris.Error.NotFoundError)

      iex> User.get!("my invalid token", "my id")
      ** (Iris.Error.UnauthorizedError)
  """
  @spec get!(user_token :: String.t(), id :: String.t()) :: %__MODULE__{}
  def get!(user_token, id) when is_binary(id) do
    return!(get(user_token, id))
  end

  defp parse({:error, error}), do: {:error, error}

  defp parse({:ok, body}) do
    {:ok, struct(__MODULE__, body)}
  end
end
