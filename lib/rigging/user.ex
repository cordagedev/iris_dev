defmodule Iris.Rigging.User do
  use Iris.Response
  use Iris.Request

  # acá hay que replicar la estructura del esquema
  defstruct name: nil

  @url "/api/v1/users/"

  def get(user_token, id) when is_binary(id) do
    response = request(:rigging, @url <> id, user_token)
    user = to_user(response)
    return user
  end

  def get!(user_token, id) when is_binary(id) do
    return! get(id, user_token) # podríamos reutilizar la otra función
  end

  defp to_user({:error, error}), do: {:error, error}
  defp to_user({:ok, body}) do
    # {:ok, %__MODULE__{}} crear el struct %User{} usando response
    {:ok, body}
  end
end
