# Create Azure SQL Database for the data layer
resource "azurerm_mssql_server" "database_server" {
  name                         = "my-database-server12345"
  resource_group_name          = var.azurerm_resource_group
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
}

resource "azurerm_mssql_database" "database" {
  name           = "database-db"
  server_id      = azurerm_mssql_server.database_server.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  }