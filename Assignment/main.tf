terraform {
    required_providers {
        azurerm = {
            source = "hashicorp/azurerm"
            version = "3.51.0"
        }
    }
}

provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "KPMG" {
    name = var.azurerm_resource_group
    location= var.location
}

# Create Azure Virtual Network
resource "azurerm_virtual_network" "VNET-KPMG" {
  name                = "VNET-KPMG"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.azurerm_resource_group
}

# Create Azure Subnet for the app tier
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = var.azurerm_resource_group
  virtual_network_name = var.azurerm_virtual_network
  address_prefixes      = ["10.0.1.0/24"] 
}

resource "azurerm_network_interface" "interface1" {
  name                = "interface1"
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "VM-DEV-WEB1" {
  count                 = 2  
  name                  = "VM-DEV-WEB${count.index}"
  resource_group_name = var.azurerm_resource_group
  location            = var.location
  size                = "Standard_F2"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.interface1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}