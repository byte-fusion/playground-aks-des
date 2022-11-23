locals {
  node_subnets = { for node in var.node_pools :
    node.name => module.network.vnet_subnets[node.subnet_name]
  }

  kubelet_identity = {
    id        = azurerm_user_assigned_identity.aks_kubelet.id
    client_id = azurerm_user_assigned_identity.aks_kubelet.client_id
    object_id = azurerm_user_assigned_identity.aks_kubelet.principal_id
  }
}

### AKS Kubelet Identity

resource "azurerm_user_assigned_identity" "aks_kubelet" {
  name                = "aks-kubelet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "aks_kubelet_identity_operator" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_kubelet.principal_id
}

resource "azurerm_role_assignment" "aks_kubelet_key_vault_reader" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Key Vault Crypto Service Encryption User" # "Key Vault Reader"
  principal_id         = azurerm_user_assigned_identity.aks_kubelet.principal_id
}



### AKS User Identity

resource "azurerm_user_assigned_identity" "aks_user" {
  name                = "aks-user"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

resource "azurerm_role_assignment" "aks_user_identity_operator" {
  scope                = azurerm_resource_group.rg.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = azurerm_user_assigned_identity.aks_user.principal_id
}

module "aks" {
  #source                   = "git@github.com:deeproute/terraform-modules-azure//aks?ref=master"
  source = "../../terraform-modules-azure/containers/aks/"

  region                  = azurerm_resource_group.rg.location
  resource_group_name     = azurerm_resource_group.rg.name
  cluster_name            = var.cluster_name
  kubernetes_version      = var.kubernetes_version
  kubelet_identity        = local.kubelet_identity
  identity_ids            = [azurerm_user_assigned_identity.aks_user.id]
  private_cluster_enabled = var.private_cluster_enabled
  network_plugin          = var.network_plugin
  network_policy          = var.network_policy
  node_pools              = var.node_pools
  node_subnets            = local.node_subnets
  # disk_encryption_set_id  = azurerm_disk_encryption_set.des.id

  depends_on = [
    module.network,
  ]
}
