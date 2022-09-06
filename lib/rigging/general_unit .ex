defmodule Iris.Rigging.GeneralUnit do
  @moduledoc """
  This module represents a *GeneralUnit* in Cordage.

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
    level
    description
    type_of_access
    organization_id
    responsible_id
  ]a

  defstruct @enforce_keys

  @url "/api/v1/general_units/"

  @doc """
  Gets a *General Unit* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the user they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Examples

      iex> GeneralUnit.get("my valid token", "my id")
      iex> {:ok, %Iris.Rigging.GeneralUnit{}}

      iex> GeneralUnit.get("my valid token", "invalid id")
      iex> {:error, %Iris.Error.NotFoundError}

      iex> GeneralUnit.get("my invalid token", "my id")
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
  Gets a *General Unit* from *Rigging*.
  Expects the token of the user making the request, along with
  the ID of the user they are looking for.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> GeneralUnit.get!("my valid token", "my id")
      iex> %Iris.Rigging.GeneralUnit{}

      iex> GeneralUnit.get!("my valid token", "invalid id")
      iex> ** Iris.Error.NotFoundError

      iex> GeneralUnit.get!("my invalid token", "my id")
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec get!(user_token :: String.t(), id :: String.t()) :: %__MODULE__{}
  def get!(user_token, id) when is_binary(id) do
    return!(get(user_token, id))
  end

  @doc """
  Validates if a list of *General Units* from *Rigging* exist.
  Expects the token of the user making the request, along with
  the ID's of the general units they are validating.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Examples

      iex> GeneralUnit.all("my valid token", ["my id"])
      iex> [%Iris.Rigging.GeneralUnit{}]

      iex> GeneralUnit.all("my valid token", "[not_existing_id]")
      iex> :not_found
  """
  @spec all(user_token :: String.t(), ids :: [String.t()]) ::
          [ %__MODULE__{}] | []
  def all(user_token, ids) when is_list(ids) do
    Enum.reduce_while(ids, [], fn id, acc ->
      general_unit =
        user_token
        |> get(id)
        |> foreign_errors()

      if :error != general_unit,
        do: {:cont, [general_unit | acc]},
        else: {:halt, :error}
    end)
  end

  @doc """
  Validates if a list of *General Units* from *Rigging* exist.
  Expects the token of the user making the request, along with
  the ID's of the general units they are validating.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> GeneralUnit.all!("my valid token", ["my id"])
      iex> [%Iris.Rigging.GeneralUnit{}]

      iex> GeneralUnit.all!("my valid token", "[not_existing_id]")
      iex> ** Iris.Error.NotFoundError

      iex> GeneralUnit.all!("my invalid token", ["my id"])
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec all!(user_token :: String.t(), ids :: [String.t()]) ::
         [ %__MODULE__{}]
  def all!(user_token, ids) when is_list(ids) do
    Enum.reduce(ids, [], fn id, acc ->
      general_unit = get!(user_token, id)
      [general_unit | acc]
    end)
  end

  #--- Private -----------------------------------------------------------------

  defp parse({:error, error}), do: {:error, error}

  defp parse({:ok, body}) do
    {:ok, struct(__MODULE__, body)}
  end

  defp foreign_errors({:error, _}), do: :error
  defp foreign_errors({:ok, general_unit}), do: general_unit
end
