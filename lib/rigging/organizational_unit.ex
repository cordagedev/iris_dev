defmodule Iris.Rigging.OrganizationalUnit do
  @moduledoc """
  This module represents a *OrganizationalUnit* in Cordage.

  Attributes:
    * id
    * name
    * code
    * description
    * level
    * parent_id
    * organization_id
    * responsible_id
  """

  import Iris.Response
  import Iris.Request

  @enforce_keys ~w[
    id
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

  @doc """
  Gets a *Organizational Unit* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the user they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Examples

      iex> OrganizationalUnit.get("my valid token", "my id")
      iex> {:ok, %Iris.Rigging.OrganizationalUnit{}}

      iex> OrganizationalUnit.get("my valid token", "invalid id")
      iex> {:error, %Iris.Error.NotFoundError}

      iex> OrganizationalUnit.get("my invalid token", "my id")
      iex> {:error, %Iris.Error.UnauthorizedError}
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
  Gets a *Organizational Unit* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the user they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> OrganizationalUnit.get!("my valid token", "my id")
      iex> %Iris.Rigging.OrganizationalUnit{}

      iex> OrganizationalUnit.get!("my valid token", "invalid id")
      iex> ** Iris.Error.NotFoundError

      iex> OrganizationalUnit.get!("my invalid token", "my id")
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec get!(user_token :: String.t(), id :: String.t()) :: %__MODULE__{}
  def get!(user_token, id) when is_binary(id) do
    return!(get(user_token, id))
  end

  @doc """
  Validates if a list of *Organizational Units* from *Rigging* exist.
  Expects the token of the user making the request, along with
  the ID's of the organizational units they are validating.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Examples

      iex> OrganizationalUnit.all("my valid token", ["my id"])
      iex> [%Iris.Rigging.OrganizationalUnit{}]

      iex> OrganizationalUnit.all("my valid token", "[not_existing_id]")
      iex> :not_found
  """
  @spec all(user_token :: String.t(), ids :: [String.t()]) ::
          [ %__MODULE__{}] | []
  def all(user_token, ids) when is_list(ids) do
    Enum.reduce_while(ids, [], fn id, acc ->
      organizational_unit =
        user_token
        |> get(id)
        |> foreign_errors()

      if :error != organizational_unit,
        do: {:cont, [organizational_unit | acc]},
        else: {:halt, :error}
    end)
  end

  @doc """
  Validates if a list of *Organizational Units* from *Rigging* exist.
  Expects the token of the user making the request, along with
  the ID's of the organizational units they are validating.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> OrganizationalUnit.all!("my valid token", ["my id"])
      iex> [%Iris.Rigging.OrganizationalUnit{}]

      iex> OrganizationalUnit.all!("my valid token", "[not_existing_id]")
      iex> ** Iris.Error.NotFoundError

      iex> OrganizationalUnit.all!("my invalid token", ["my id"])
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec all!(user_token :: String.t(), ids :: [String.t()]) ::
         [ %__MODULE__{}]
  def all!(user_token, ids) when is_list(ids) do
    Enum.reduce(ids, [], fn id, acc ->
      organizational_unit = get!(user_token, id)
      [organizational_unit | acc]
    end)
  end

  #--- Private -----------------------------------------------------------------

  defp parse({:error, error}), do: {:error, error}

  defp parse({:ok, body}) do
    {:ok, struct(__MODULE__, body)}
  end

  defp foreign_errors({:error, _}), do: :error
  defp foreign_errors({:ok, organizational_unit}), do: organizational_unit
end
