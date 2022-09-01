defmodule OrganizationalUnitTest do
  use ExUnit.Case, async: false

  import Mock

  alias Iris.Rigging.OrganizationalUnit

  @organizational_unit_id "eff17a61-9e42-4fa4-8a9a-48f7b5227759"
  @token "test"

  describe "get/2" do
    test_with_mock "returns an organizational unit",
                   HTTPoison,
                   get: &success/2 do
      assert {:ok,
              %OrganizationalUnit{
                name: _name,
                code: _code,
                description: _description,
                level: _level,
                parent_id: _parent_id,
                organization_id: _organization_id,
                responsible_id: _responsible_id
              }} = OrganizationalUnit.get(@token, @organizational_unit_id)
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert {:error, %Iris.Error.UnauthorizedError{}} =
               OrganizationalUnit.get(@token, @organizational_unit_id)
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert {:error, %Iris.Error.NotFoundError{}} =
               OrganizationalUnit.get(@token, @organizational_unit_id)
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert {:error, %Iris.Error.ServerError{}} =
               OrganizationalUnit.get(@token, @organizational_unit_id)
    end
  end

  describe "get!/2" do
    test_with_mock "returns an organizational unit",
                   HTTPoison,
                   get: &success/2 do
      assert %OrganizationalUnit{
               name: _name,
               code: _code,
               description: _description,
               level: _level,
               parent_id: _parent_id,
               organization_id: _organization_id,
               responsible_id: _responsible_id
             } = OrganizationalUnit.get!(@token, @organizational_unit_id)
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        OrganizationalUnit.get!(@token, @organizational_unit_id)
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        OrganizationalUnit.get!(@token, @organizational_unit_id)
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        OrganizationalUnit.get!(@token, @organizational_unit_id)
      end
    end
  end

  describe "all/2" do
    test_with_mock "returns a organizational unit",
                   HTTPoison,
                   get: &success/2 do
      assert is_list(OrganizationalUnit.all(@token, [@organizational_unit_id]))
    end

    test_with_mock "returns {:error, %UnauthorizedError{}} if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert :error =
               OrganizationalUnit.all(@token, [@organizational_unit_id])
    end

    test_with_mock "returns {:error, %NotFoundError{}} if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert :error = OrganizationalUnit.all(@token, [@organizational_unit_id])
    end

    test_with_mock "returns {:error, %ServerError{}} if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert :error = OrganizationalUnit.all(@token, [@organizational_unit_id])
    end
  end

  describe "all!/2" do
    test_with_mock "returns a organizational unit",
                   HTTPoison,
                   get: &success/2 do
      assert is_list(OrganizationalUnit.all!(@token, [@organizational_unit_id]))
    end

    test_with_mock "raises UnauthorizedError if token is invalid",
                   HTTPoison,
                   get: &unauthorized/2 do
      assert_raise Iris.Error.UnauthorizedError, fn ->
        OrganizationalUnit.all!(@token, [@organizational_unit_id])
      end
    end

    test_with_mock "raises NotFoundError if no id matches",
                   HTTPoison,
                   get: &not_found/2 do
      assert_raise Iris.Error.NotFoundError, fn ->
        OrganizationalUnit.all!(@token, [@organizational_unit_id])
      end
    end

    test_with_mock "raises a ServerError if rigging doesn't respond",
                   HTTPoison,
                   get: &server_error/2 do
      assert_raise Iris.Error.ServerError, fn ->
        OrganizationalUnit.all!(@token, [@organizational_unit_id])
      end
    end
  end

  defp success(_url, _headers) do
    {:ok,
     %HTTPoison.Response{
       status_code: 200,
       body: """
       {
         "id": "#{@organizational_unit_id}",
         "name": "test",
         "code": "TEST12",
         "description": "description :)",
         "parent_id": "eff17a61-9e42-4fa4-8a9a-48f7b5227750",
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
