resource "azurerm_kubernetes_cluster" "cluster" {
  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
  name                      = "${var.prefix}-aks"
  location                  = var.location
  resource_group_name       = var.resource_group_name
  dns_prefix                = "fluxsingle"
  kubernetes_version        = var.aks_version
  automatic_upgrade_channel = "patch"
  default_node_pool {
    name                         = "system"
    os_sku                       = "AzureLinux"
    orchestrator_version         = var.aks_version
    auto_scaling_enabled         = true
    node_count                   = 1
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 200
    vm_size                      = "Standard_B2s_v2"
    only_critical_addons_enabled = true
    temporary_name_for_rotation  = "system99"
    vnet_subnet_id               = azurerm_subnet.dual_subnet_system.id
    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Experiment"
  }
  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    ip_versions         = ["IPv4", "IPv6"] # Azure did not like IPv6 first
    pod_cidrs           = ["10.240.0.0/16", "fd10:59f0:8c79:240::/64"]
    service_cidrs       = ["10.250.0.0/24", "fd10:59f0:8c79:250::/108"]
    dns_service_ip      = "10.250.0.10"
    load_balancer_sku   = "standard"
  }
}

resource "azurerm_kubernetes_cluster_node_pool" "workpool" {
  depends_on = [ azurerm_kubernetes_cluster.cluster ]
  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
  name                        = "worker"
  os_sku                      = "AzureLinux"
  kubernetes_cluster_id       = azurerm_kubernetes_cluster.cluster.id
  vnet_subnet_id              = azurerm_subnet.dual_subnet_work.id
  max_pods                    = 200
  auto_scaling_enabled        = true
  vm_size                     = "Standard_B2s_v2"
  node_count                  = 0
  min_count                   = 0
  max_count                   = 3
  zones                       = ["1", "2", "3"]
  temporary_name_for_rotation = "worker99"
  orchestrator_version        = var.aks_version
  upgrade_settings {
    max_surge = "10%"
  }
}

resource "azurerm_kubernetes_cluster_extension" "flux" {
  depends_on     = [azurerm_kubernetes_cluster_node_pool.workpool]
  name           = "${var.prefix}-flux"
  cluster_id     = azurerm_kubernetes_cluster.cluster.id
  extension_type = "microsoft.flux"
  configuration_settings = {
    "useKubeletIdentity"      = "true"
    "autoUpgradeMinorVersion" = "true"
    "multiTenancy.enforce"    = "false"
  }
}

output "kubelet_identity_object_id" {
  value = azurerm_kubernetes_cluster.cluster.kubelet_identity[0].object_id
}