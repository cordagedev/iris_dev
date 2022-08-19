defmodule Iris.Response do
  alias Iris.Error

  def return({:error, error}) do
    {:error, error}
  end

  def return({:ok, res}), do: {:ok, res}

  def return!({:error, :not_found}), do: raise Error.NotFoundError

  def return!({:error, error}) do
    raise error
  end

  def return!({:ok, res}), do: res
end
