defmodule GeneralUnitTest do
  use ExUnit.Case, async: false

  import Mock

  alias Iris.Rigging.GeneralUnit

  @general_unit_id "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
  @token "test"

  describe "get/2" do
    test_with_mock "returns an general unit",
                   HTTPoison,
                   get: &success/2 do
      assert {:ok, %GeneralUnit{}} = GeneralUnit.get(@token, @general_unit_id)
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert {:error, %Iris.Error.UnauthorizedError{}} =
               GeneralUnit.get(@token, @general_unit_id)
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert {:error, %Iris.Error.NotFoundError{}} =
               GeneralUnit.get(@token, @general_unit_id)
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert {:error, %Iris.Error.ServerError{}} =
               GeneralUnit.get(@token, @general_unit_id)
    end
  end

  describe "get!/2" do
    test_with_mock "returns an general unit",
                   HTTPoison,
                   get: &success/2 do
      assert %GeneralUnit{} = GeneralUnit.get!(@token, @general_unit_id)
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        GeneralUnit.get!(@token, @general_unit_id)
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        GeneralUnit.get!(@token, @general_unit_id)
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        GeneralUnit.get!(@token, @general_unit_id)
      end
    end
  end

  describe "all/2" do
    test_with_mock "returns a general unit",
                   HTTPoison,
                   get: &success/2 do
      assert is_list(GeneralUnit.all(@token, [@general_unit_id]))
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert :error =
               GeneralUnit.all(@token, [@general_unit_id])
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert :error = GeneralUnit.all(@token, [@general_unit_id])
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert :error = GeneralUnit.all(@token, [@general_unit_id])
    end
  end

  describe "all!/2" do
    test_with_mock "returns a general unit",
                   HTTPoison,
                   get: &success/2 do
      assert is_list(GeneralUnit.all!(@token, [@general_unit_id]))
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        GeneralUnit.all!(@token, [@general_unit_id])
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        GeneralUnit.all!(@token, [@general_unit_id])
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        GeneralUnit.all!(@token, [@general_unit_id])
      end
    end
  end

  defp success(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: """
       {
         "id": "#{@general_unit_id}",
         "name": "test",
         "code": "TEST12",
         "description": "description :)",
         "organization_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227751",
         "responsible_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227752"
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
