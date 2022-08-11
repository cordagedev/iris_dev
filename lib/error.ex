defmodule Iris.Error do
  defmodule NotFoundError do
    defexception [message: "resource not found"]
  end

  defmodule ServerTimeoutError do
    defexception [message: "server didn't respond in time"]
  end
end
