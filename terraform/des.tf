# Create key vault key to be used with DES
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

# Create the DES Azure Resource and use the key above
resource "azurerm_disk_encryption_set" "des" {
  name                      = "des"
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  key_vault_key_id          = azurerm_key_vault_key.des_key.id
  auto_key_rotation_enabled = true

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_key_vault_key.des_key]
}

# Allow the DES to access the key in Key Vault
resource "azurerm_role_assignment" "des" {
  scope                = module.akv.key_vault_id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_disk_encryption_set.des.identity.0.principal_id
}