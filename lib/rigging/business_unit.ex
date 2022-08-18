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
    return!(get(user_token, id))
  end

  @doc """
  Validates if a list of *Business Units* from *Rigging* exist.
  Expects the token of the user making the request, along with
  the ID's of the business units they are validating.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Examples

      iex> BusinessUnit.foreign_business_units_keys("my valid token", ["my id"])
      iex> [%Iris.Rigging.BusinessUnit{}]

      iex> BusinessUnit.foreign_business_units_keys("my valid token", "[not_existing_id]")
      iex> :not_found
  """
  @spec foreign_business_units_keys(user_token :: String.t(), ids :: [String.t()]) ::
          [ %__MODULE__{}] | :not_found
  def foreign_business_units_keys(user_token, ids) when is_list(ids) do
    Enum.reduce_while(ids, [], fn id, acc ->
      business_unit =
        user_token
        |> get(id)
        |> foreign_errors()

      if :error != business_unit,
        do: {:cont, acc ++ [business_unit]},
        else: {:halt, :not_found}
    end)
  end

  @doc """
  Validates if a list of *Business Units* from *Rigging* exist.
  Expects the token of the user making the request, along with
  the ID's of the business units they are validating.

  > Token must *not* contain the "Bearer" prefix.
  > Also, the authorization login will be enforce
  > by *Rigging*.

  Raises a `Iris.Error.NotFoundError` if no record is matched.

  Raises a `Iris.Error.UnauthorizedError` if *Rigging* sends an "unauthorized" response.

  Examples

      iex> BusinessUnit.foreign_business_units_keys!("my valid token", ["my id"])
      iex> [%Iris.Rigging.BusinessUnit{}]

      iex> BusinessUnit.foreign_business_units_keys!("my valid token", "[not_existing_id]")
      iex> ** Iris.Error.NotFoundError

      iex> BusinessUnit.foreign_business_units_keys!("my invalid token", ["my id"])
      iex> ** Iris.Error.UnauthorizedError
  """
  @spec foreign_business_units_keys!(user_token :: String.t(), ids :: [String.t()]) ::
         [ %__MODULE__{}]
  def foreign_business_units_keys!(user_token, ids) when is_list(ids) do
    Enum.reduce(ids, [], fn id, acc ->
      business_unit = get!(user_token, id)
      acc ++ [business_unit]
    end)
  end

  # --- Private ----------------------------------------------------------------

  defp parse({:error, error}), do: {:error, error}
  defp parse({:ok, body}), do: {:ok, struct(__MODULE__, body)}

  defp foreign_errors({:error, _}), do: :error
  defp foreign_errors({:ok, business_unit}), do: business_unit
end
