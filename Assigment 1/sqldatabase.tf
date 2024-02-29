
resource "azurerm_mssql_server" "sqlserverkpmg" {
  name                         = "sqlserverkpmg"
  resource_group_name          = local.resource_group_name
  location                     = local.location
  version                      = "12.0"
  administrator_login          = "sqladmin"
  administrator_login_password = "Azure@3456"
  depends_on = [
    azurerm_resource_group.kpmgrg
  ]
}

resource "azurerm_mssql_database" "appdb" {
  name           = "appdb"
  server_id      = azurerm_mssql_server.sqlserverkpmg.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
  depends_on = [
    azurerm_mssql_server.sqlserverkpmg
]
}

resource "azurerm_mssql_database" "appdb2" {
  name           = "appdb2"
  server_id      = azurerm_mssql_server.sqlserverkpmg.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
  depends_on = [
    azurerm_mssql_server.sqlserverkpmg
]
}