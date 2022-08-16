defmodule Iris.Rigging.Structs.Organization do
  @enforce_keys [
    :name,
    :display_name,
    :auth0_id,
    :responsible_id,
    :main_business_unit_id
  ]

  defstruct [
    :name,
    :display_name,
    :auth0_id,
    :responsible_id,
    :main_business_unit_id,
    :business_units,
    :organizational_units,
    :general_units
  ]
end
