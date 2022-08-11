defmodule Iris do
end

alias Iris.Rigging.User
user = User.get("some id")
IO.inspect(user)
IO.inspect("hello")
