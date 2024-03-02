variable "azurerm_resource_group" {
    default = "KPMG"
}

variable "location" {
    default = "West US"
}

variable "azurerm_virtual_network" {
    default = "VNET-KPMG"
}

variable "azurerm_subnet" {
    default = "app_subnet"
}

variable "admin_username" {
    default = "abc"
}

variable "admin_password" {
   default = "abc"
}

variable "administrator_login" {
    default = "abc"
}

variable "administrator_login_password" {
    default = "abc"
}

variable "backend_ip_addresses" {
  type    = list(string)
  default = ["10.0.1.5", "10.0.1.4"]
}