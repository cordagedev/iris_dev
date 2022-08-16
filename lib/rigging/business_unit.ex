defmodule Iris.Rigging.BusinessUnit do
  use Iris.Response
  use Iris.Request

  @url "/api/v1/business_units/"

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

  defstruct [
    :active,
    :address,
    :code,
    :colors_theme,
    :datetime_config,
    :description,
    :favicon,
    :general_units,
    :id,
    :inserted_at,
    :logo,
    :main,
    :name,
    :organization,
    :organization_id,
    :organizational_units,
    :responsible,
    :responsible_id,
    :social_reason,
    :timezone,
    :updated_at,
    :users
  ]
end