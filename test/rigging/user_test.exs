defmodule UserTest do
  use ExUnit.Case, async: true

  import Mock

  alias Iris.Rigging.User

  @user_id "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
  @token "test"

  describe "get/2" do
    test_with_mock "returns a user",
                   HTTPoison,
                   get: &success/2 do
      assert {:ok, %User{}} = User.get(@token, @user_id)
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert {:error, %Iris.Error.UnauthorizedError{}} = User.get(@token, @user_id)
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert {:error, %Iris.Error.NotFoundError{}} = User.get(@token, @user_id)
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert {:error, %Iris.Error.ServerError{}} = User.get(@token, @user_id)
    end
  end

  describe "get!/2" do
    test_with_mock "returns a user",
                   HTTPoison,
                   get: &success/2 do
      assert %User{} = User.get!(@token, @user_id)
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        User.get!(@token, @user_id)
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        User.get!(@token, @user_id)
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        User.get!(@token, @user_id)
      end
    end
  end

  defp success(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: """
       {
         "id": "#{@user_id}",
         "first_name": "Alice",
         "last_name": "Doe",
         "email": "alice@cordage.io",
         "timezone": "Americas/Mexico_City",
         "auth0_id": "auth0|62dad28ddbfb90d69d29b4ae",
         "type": "Basic",
         "status": "Invited",
         "language": "EN",
         "organization_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759",
         "organizational_unit_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759",
         "job_title_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
       }
       """
     }}
  end

  defp unauthorized(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 401,
       body: "unauthorized"
     }}
  end

  defp not_found(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 404,
       body: "not found"
     }}
  end

  defp server_error(_url, _headers) do
    {:error,
     %HTTPoison.Response{
       status_code: 500,
       body: "server dead"
     }}
  end
end
