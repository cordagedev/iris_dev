defmodule Iris.Rigging.User do
  use Iris.Response

  defstruct name: nil

  def get(id) when is_binary(id) do
    # ask redis
    # if is not in redis
    # ask rigging
    # HTTPoison.get(...)
    # return(%__MODULE__{name: "John Doe"})
    return nil
  end

  def get!(id) when is_binary(id) do
    # return!(%__MODULE__{name: "John Doe"})
    return! nil
  end
end
