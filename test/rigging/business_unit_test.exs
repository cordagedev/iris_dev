defmodule Iris.Rigging.BusinessUnitTest do
  use ExUnit.Case, async: false

  import Mock

  alias Iris.Rigging.BusinessUnit

  @business_unit_id "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
  @token "test"

  describe "get/2" do
    test_with_mock "returns a business unit",
                   HTTPoison,
                   get: &success/2 do
      assert {:ok, %BusinessUnit{}} = BusinessUnit.get(@token, @business_unit_id)
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert {:error, %Iris.Error.UnauthorizedError{}} =
               BusinessUnit.get(@token, @business_unit_id)
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert {:error, %Iris.Error.NotFoundError{}} = BusinessUnit.get(@token, @business_unit_id)
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert {:error, %Iris.Error.ServerError{}} = BusinessUnit.get(@token, @business_unit_id)
    end
  end

  describe "get!/2" do
    test_with_mock "returns a business unit",
                   HTTPoison,
                   get: &success/2 do
      assert %BusinessUnit{} = BusinessUnit.get!(@token, @business_unit_id)
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        BusinessUnit.get!(@token, @business_unit_id)
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        BusinessUnit.get!(@token, @business_unit_id)
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        BusinessUnit.get!(@token, @business_unit_id)
      end
    end
  end

  defp success(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: """
       {
         "id": "#{@business_unit_id}",
         "active": true,
         "name": "Cordage",
         "code": "COR",
         "description": "Business Unit of development",
         "social_reason": "Cordage",
         "address": {
          "first_line": "Access lll",
          "postal_code": 54678,
          "country": "MX",
          "subdivision": "Querétaro",
          "location": "Querétaro"
         },
         "timezone": "Americas/Mexico_City",
         "organization_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759",
         "responsible_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
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
