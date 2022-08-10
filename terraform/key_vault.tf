module "akv" {
  source                          = "../../tf-modules-azure/akv/"

  region                          = azurerm_resource_group.rg.location
  resource_group_name             = azurerm_resource_group.rg.name
  name                            = var.key_vault_name
  randomize_name_suffix           = var.key_vault_randomize_name_suffix
  sku_name                        = var.key_vault_sku_tier
  disk_encryption_access_enabled  = var.key_vault_disk_encryption_access_enabled
  vm_access_enabled               = var.key_vault_vm_access_enabled
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  enable_rbac                     = var.key_vault_enable_rbac
  certificate_permissions         = var.key_vault_certificate_permissions
  key_permissions                 = var.key_vault_key_permissions
  secret_permissions              = var.key_vault_secret_permissions
}

resource "azurerm_key_vault_key" "des_key" {
  name         = "des-key"
  key_vault_id = module.akv.key_vault_id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

resource "azurerm_disk_encryption_set" "des" {
  name                = "des"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.des_key.id

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_key_vault_key.des_key]
}

resource "azurerm_role_assignment" "des" {
  scope                = module.akv.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des.identity.0.principal_id
}