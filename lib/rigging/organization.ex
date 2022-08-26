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
    :main_business_unit_id,
    :id
  ]

  @derive Jason.Encoder
  defstruct @enforce_keys

  @url "/api/v1/organizations/"

  @doc """
  Gets the *Organization* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the organization they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce by *Rigging*.

  Examples

      iex> Organization.get("my valid token", "my id")
      iex> {:ok, %Iris.Rigging.Organization{}}

      iex> Organization.get("my valid token", "invalid id")
      iex> {:error, %Iris.Error.NotFoundError}

      iex> Organization.get("my invalid token", "my id")
      iex> {:error, %Iris.Error.UnauthorizedError}
  """
  @spec get(user_token :: String.t(), id :: String.t()) ::
          {:ok, %__MODULE__{}}
          | {:error, %Iris.Error.NotFoundError{}}
          | {:error, %Iris.Error.UnauthorizedError{}}
  def get(user_token, id) when is_binary(id) do
    request(:rigging, @url <> id, user_token)
    |> parse
    |> return
  end

  @doc """
  Gets the *Organization* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the organization they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> Organization.get!("my valid token", "my id")
      iex> %Iris.Rigging.Organization{}

      iex> Organization.get!("my valid token", "invalid id")
      iex> ** Iris.Error.NotFoundError

      iex> Organization.get!("my invalid token", "my id")
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec get!(user_token :: String.t(), id :: String.t()) :: %__MODULE__{}
  def get!(user_token, id) when is_binary(id) do
    return!(get(user_token, id))
  end

  def all(user_token, ids) when is_list(ids) do
    ids
    |> Enum.map(&Task.async(fn -> get(user_token, &1) end))
    |> Task.await_many(3000) # timeout
    |> format_list()
    |> return()
  end

  def all!(user_token, ids) when is_list(ids), do: return!(all(user_token, ids))

  # --- Private ----------------------------------------------------------------

  # probablemente ahora sí sea bueno meter el tools para mover ésta
  # y la de extract_data ahí, todos los modulos van a usar las mismas
  defp format_list(results) do
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

  defp parse({:error, error}), do: {:error, error}
  defp parse({:ok, body}), do: {:ok, struct(__MODULE__, body)}
end
