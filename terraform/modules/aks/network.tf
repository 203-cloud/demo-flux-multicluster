resource "azurerm_virtual_network" "dual_vnet" {
  name                = "flux-single-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space = [
    "10.10.0.0/16",
    "fd3b:e9fb:d874::/56"
  ]
}

resource "azurerm_subnet" "dual_subnet_system" {
  name                 = "flux-single-system"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.dual_vnet.name
  address_prefixes = [
    "fd3b:e9fb:d874:1::/64",
    "10.10.1.0/24"
  ]
}

resource "azurerm_subnet" "dual_subnet_work" {
  name                 = "flux-single-work"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.dual_vnet.name
  address_prefixes = [
    "fd3b:e9fb:d874:2::/64",
    "10.10.2.0/24"
  ]
}
