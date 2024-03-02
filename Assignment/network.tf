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
  dynamic "backend_address" {
    for_each = var.backend_ip_addresses
    content {
      ip_address = backend_ip_addresses.value
    }
  }
}

# Connect the application tier to the database tier
resource "azurerm_virtual_machine_extension" "app_db_extension_0" {
  name                 = "app-db-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM-DEV-APP[0].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "sudo apt-get update && sudo apt-get install -y mysql-client"
    }
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "app_db_extension_1" {
  name                 = "app-db-extension"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM-DEV-APP[1].id
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
resource "azurerm_virtual_machine_extension" "app_db_connection_0" {
  name                 = "app-db-connection-0"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM-DEV-APP[0].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "echo 'export DB_CONNECTION_STRING=<YOUR_DATABASE_CONNECTION_STRING>' >> /etc/environment"
    }
  SETTINGS
}

resource "azurerm_virtual_machine_extension" "app_db_connection_1" {
  name                 = "app-db-connection-1"
  virtual_machine_id   = azurerm_windows_virtual_machine.VM-DEV-APP[1].id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
    {
        "commandToExecute": "echo 'export DB_CONNECTION_STRING=<YOUR_DATABASE_CONNECTION_STRING>' >> /etc/environment"
    }
  SETTINGS
}
