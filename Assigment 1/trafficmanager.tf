resource "azurerm_traffic_manager_profile" "app-profile" {
  name                   = "app-profile"
  resource_group_name    = local.resource_group_name
  traffic_routing_method = "Weighted"

  dns_config {
    relative_name = app-profile
    ttl           = 100
  }

  monitor_config {
    protocol                     = "HTTPS"
    port                         = 443
    path                         = "/"
    interval_in_seconds          = 30
    timeout_in_seconds           = 9
    tolerated_number_of_failures = 3
  }
depends_on = [
  azurerm_resource_group.kpmgrg
]
}

resource "azurerm_traffic_manager_azure_endpoint" "primaryapp" {
  name               = "primaryapp"
  profile_id         = azurerm_traffic_manager_profile.app-profile
  weight             = 100
  target_resource_id = azurerm_windows_webapp.primaryapp.id

  custom_header {
    name = "host"
    value= "${azurerm_windows_webapp.primaryapp.id}"
  }
}

resource "azurerm_traffic_manager_azure_endpoint" "secondaryapp" {
  name               = "secondaryapp"
  profile_id         = azurerm_traffic_manager_profile.app-profile
  weight             = 200
  target_resource_id = azurerm_windows_webapp.secondaryapp.id

  custom_header {
    name = "host"
    value= "${azurerm_windows_webapp.secondaryapp.id}"
  }
}