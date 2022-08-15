defmodule Iris.Request do
  defmacro __using__(_module) do
    quote do
      @rigging_url System.get_env("RIGGING_URL")

      def request(:rigging, url, token) do
        make_request("#{@rigging_url}#{url}", token)
      end

      defp make_request(url, token) do
        case HTTPoison.get(url, %{"Authorization" => token}) do
          {:error, _error} ->
            {:error, %Iris.Error.ServerError{}}

          {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
            {:ok, Jason.decode!(body)}

          {:ok, %HTTPoison.Response{status_code: 404}} ->
            {:error, %Iris.Error.NotFoundError{}}

          {:ok, %HTTPoison.Response{status_code: 401}} ->
            {:error, %Iris.Error.UnauthorizedError{}}

          {:ok, %HTTPoison.Response{status_code: 400}} ->
            {:error, %Iris.Error.BadRequestError{}}
        end
      end
    end
  end
end