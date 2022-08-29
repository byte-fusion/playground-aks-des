module "akv" {
  source = "../../terraform-modules-azure/akv/"

  region                         = azurerm_resource_group.rg.location
  resource_group_name            = azurerm_resource_group.rg.name
  name                           = var.key_vault_name
  randomize_name_suffix          = var.key_vault_randomize_name_suffix
  sku_name                       = var.key_vault_sku_tier
  disk_encryption_access_enabled = var.key_vault_disk_encryption_access_enabled
  vm_access_enabled              = var.key_vault_vm_access_enabled
  soft_delete_retention_days     = var.key_vault_soft_delete_retention_days
  purge_protection_enabled       = var.key_vault_purge_protection_enabled
  enable_rbac                    = var.key_vault_enable_rbac
  certificate_permissions        = var.key_vault_certificate_permissions
  key_permissions                = var.key_vault_key_permissions
  secret_permissions             = var.key_vault_secret_permissions
}
