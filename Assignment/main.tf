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
    name = "KPMG"
    location= "West US"
}

# Create Azure Virtual Network
resource "azurerm_virtual_network" "VNET-KPMG" {
  name                = "VNET-KPMG"
  address_space       = ["10.0.0.0/16"]
  location            = "westus" 
  resource_group_name = "KPMG"
}

# Create Azure Subnet for the app tier
resource "azurerm_subnet" "app_subnet" {
  name                 = "app-subnet"
  resource_group_name  = "KPMG"
  virtual_network_name = "VNET-KPMG"
  address_prefixes      = ["10.0.1.0/24"] 
}