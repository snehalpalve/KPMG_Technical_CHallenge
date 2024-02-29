resource "azurerm_service_plan" "kpmgplan" {
  name                = "kpmgplan"
  location            = local.location
  resource_group_name = local.resource_group_name
  os_type             = "Windows"
  sku_name            = "B1"
  depends_on = [
    azurerm_resource_group.kpmgrg
  ]
}

resource "azurerm_windows_web_app" "kpmgwebapp1" {
  name                = "kpmgwebapp1"
  resource_group_name = local.resource_group_name
  location            = local.location
  service_plan_id     = azurerm_service_plan.kpmgplan.id

  site_config {
    application_stack {
      current_stack = "dotnet"
      dotnet_version = "v6.0"
  }
}
depends_on = [
  azurerm_service_plan.kpmgplan
]
}

