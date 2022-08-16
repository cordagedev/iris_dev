defmodule Iris.Rigging.Structs.BusinessUnit do
  @enforce_keys [
    :active,
    :name,
    :code,
    :description,
    :social_reason,
    :address,
    :timezone,
    :organization_id,
    :responsible_id
  ]

  defstruct [
    :active,
    :address,
    :code,
    :colors_theme,
    :datetime_config,
    :description,
    :favicon,
    :general_units,
    :id,
    :inserted_at,
    :logo,
    :main,
    :name,
    :organization,
    :organization_id,
    :organizational_units,
    :responsible,
    :responsible_id,
    :social_reason,
    :timezone,
    :updated_at,
    :users
  ]
end
