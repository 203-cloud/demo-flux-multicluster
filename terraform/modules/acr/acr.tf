resource "azurerm_container_registry" "flux_single" {
  name                = "${var.prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false
}

resource "azurerm_role_assignment" "acr_pull_role" {
  for_each = var.acr_pullers
  principal_id                     = each.value
  role_definition_name             = "AcrPull"
  scope                            = azurerm_container_registry.flux_single.id
  skip_service_principal_aad_check = true
}

output "acr_url" {
  value = azurerm_container_registry.flux_single.login_server
}