defmodule Iris.Response do
  def return({:error, error}) do
    {:error, error}
  end

  def return({:ok, res}), do: {:ok, res}

  def return!({:error, error}) do
    raise error
  end

  def return!({:ok, res}), do: res
end
