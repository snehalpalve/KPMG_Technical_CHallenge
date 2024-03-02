# Create Azure Virtual Network Rule to allow access from app tier
resource "azurerm_mssql_virtual_network_rule" "app_network_rule" {
  name      = "sql-vnet-rule"
  server_id = azurerm_mssql_server.database_server.id
  subnet_id = azurerm_subnet.app_subnet.id
}

# Connect the web tier to the application tier
resource "azurerm_lb_backend_address_pool" "web_backend_pool" {
  name                = "web-backend-pool"
  loadbalancer_id     = azurerm_lb.web_lb.id

  dynamic "backend_addresses" {
    for_each = azurerm_windows_virtual_machine.VM-DEV-WEB[count.index]
    content {
      ip_address = backend_addresses.value.private_ip_address
    }
  }
}

# Connect the application tier to the database tier
resource "azurerm_virtual_machine_extension" "app_db_extension" {
  name                 = "app-db-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM-DEV-APP[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo apt-get update && sudo apt-get install -y mysql-client"
    }
  SETTINGS
}

# Configure database connection string in the application tier
resource "azurerm_virtual_machine_extension" "app_db_connection" {
  name                 = "app-db-connection"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM-DEV-APP[count.index].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "echo 'export DB_CONNECTION_STRING=<YOUR_DATABASE_CONNECTION_STRING>' >> /etc/environment"
    }
  SETTINGS
}