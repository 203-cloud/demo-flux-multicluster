resource "azurerm_resource_group" "dev" {
  name     = "flux-dev"
  location = "Norway East"
}

resource "azurerm_resource_group" "staging" {
  name     = "flux-staging"
  location = "Norway East"
}

resource "azurerm_resource_group" "common" {
    name     = "flux-common"
    location = "Norway East"
}

module "dev_aks" {
  source = "./modules/aks"

  prefix             = "dev"
  resource_group_name = azurerm_resource_group.dev.name
  location           = azurerm_resource_group.dev.location
}

module "staging_aks" {
  source = "./modules/aks"

  prefix             = "staging"
  resource_group_name = azurerm_resource_group.staging.name
  location           = azurerm_resource_group.staging.location
}

resource "random_pet" "acr_random" {
    length = 1
}

module "acr" {
  source = "./modules/acr"

  prefix             = "${random_pet.acr_random.id}flux"
  resource_group_name = azurerm_resource_group.common.name
  location           = azurerm_resource_group.common.location
  acr_pullers        = {
    dev = module.dev_aks.kubelet_identity_object_id,
    staging = module.staging_aks.kubelet_identity_object_id
  }
}

output "acr_url" {
    value = module.acr.acr_url
}