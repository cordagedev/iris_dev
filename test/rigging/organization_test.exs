defmodule Iris.Rigging.OrganizationTest do
  use ExUnit.Case, async: false

  import Mock

  alias Iris.Rigging.Organization

  @organization_id "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
  @token "test"

  describe "get/2" do
    test_with_mock "returns a organization",
                   HTTPoison,
                   get: &success/2 do
      assert {:ok, %Organization{}} = Organization.get(@token, @organization_id)
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert {:error, %Iris.Error.UnauthorizedError{}} = Organization.get(@token, @organization_id)
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert {:error, %Iris.Error.NotFoundError{}} = Organization.get(@token, @organization_id)
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert {:error, %Iris.Error.ServerError{}} = Organization.get(@token, @organization_id)
    end
  end

  describe "get!/2" do
    test_with_mock "returns a organization",
                   HTTPoison,
                   get: &success/2 do
      assert %Organization{} = Organization.get!(@token, @organization_id)
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        Organization.get!(@token, @organization_id)
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        Organization.get!(@token, @organization_id)
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        Organization.get!(@token, @organization_id)
      end
    end
  end

  defp success(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: """
       {
         "id": "#{@organization_id}",
         "name": "#{@organization_id}",
         "display_name": "iCorp",
         "auth0_id": "auth0|62dad28ddbfb90d69d29b4ae",
         "responsible_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759",
         "main_business_unit_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
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
