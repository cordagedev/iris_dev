defmodule Iris.Error do
  defmodule NotFoundError do
    defexception [message: "resource not found"]
  end

  defmodule ServerError do
    defexception [message: "could not connect to server"]
  end

  defmodule UnauthorizedError do
    defexception [message: "unauthorized"]
  end

  defmodule BadRequestError do
    defexception [message: "bad request"]
  end
end
