defmodule Iris.Request do
  def request(:rigging, url, token), do:
    make_request("#{rigging_url()}#{url}", token)

  defp make_request(url, token) do
    case HTTPoison.get(url, %{"Authorization" => "Bearer " <> token}) do
      {:error, _error} ->
        {:error, %Iris.Error.ServerError{}}

      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Jason.decode!(body, keys: :atoms)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, %Iris.Error.NotFoundError{}}

      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error, %Iris.Error.UnauthorizedError{}}

      {:ok, %HTTPoison.Response{status_code: 400}} ->
        {:error, %Iris.Error.BadRequestError{}}
    end
  end

  defp rigging_url(), do: Application.get_env(:iris, :rigging_url)
end
