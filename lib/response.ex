defmodule Iris.Response do
  defmacro __using__(_module) do
    quote do
      def return({:error, error}) do
        {:error, error}
      end

      def return({:ok, res}), do: {:ok, res}


      def return!({:error, error}) do
        raise error
      end

      def return!({:ok, res}), do: res
    end
  end
end
