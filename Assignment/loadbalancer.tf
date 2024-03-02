# Create Azure Load Balancer for web tier
resource "azurerm_public_ip" "web_lb_public_ip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  allocation_method   = "Static"
}

resource "azurerm_lb" "web_lb" {
  name                = "web-lb"
  location            = var.location
  resource_group_name = var.azurerm_resource_group

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.web_lb_public_ip.id
  }
}