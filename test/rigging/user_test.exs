defmodule UserTest do
  use ExUnit.Case, async: true

  import Mock

  describe "get/2" do
    test_with_mock "returns a user",
                   HTTPoison,
                   get: &user/1 do
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &user/1 do
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &user/1 do
    end
  end

  describe "get!/2" do
    test_with_mock "returns a user",
                   HTTPoison,
                   get: &user/1 do
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &user/1 do
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &user/1 do
    end
  end

  defp user(_) do
    %{}
  end
end
