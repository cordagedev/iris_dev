defmodule Iris.Tools do
  alias Iris.Rigging.{Organization, BusinessUnit}

  def parse({:error, error}, _), do: {:error, error}

  def parse({:ok, body}, :organization) do
    {:ok, struct(Organization, body)}
  end

  def parse({:ok, body}, :business_unit) do
    {:ok, struct(BusinessUnit, body)}
  end
end
