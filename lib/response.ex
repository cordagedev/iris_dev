defmodule Iris.Response do
  defmacro __using__(_module) do
    quote do
      def return(nil) do
        {:error, :not_found}
      end

      def return(res), do: {:ok, res}

      def return!(nil) do
        raise Iris.Error.NotFoundError
      end

      def return!(res), do: res
    end
  end
end
