region                                    = "westeurope"
resource_group_name                       = "playground-aks-disks"

### INFRA
vnet_name                                 = "infra"
vnet_address_spaces                       = [ "10.100.0.0/16" ]
vnet_subnets                              = [{
                                              name                = "aks-subnet"
                                              vnet_name           = "infra"
                                              address_prefixes    = [ "10.100.1.0/24" ]
                                            }]

### KEY VAULT
key_vault_name                            = "akv-disk"
key_vault_randomize_name_suffix           = true # Using it to avoid getting the same destroyed AKV by always using the same name
key_vault_sku_tier                        = "standard"
key_vault_disk_encryption_access_enabled  = true
key_vault_vm_access_enabled               = true
key_vault_soft_delete_retention_days      = 7
key_vault_purge_protection_enabled        = true
key_vault_enable_rbac                     = true # RBAC is the preferred role way to assign roles over the keys.
key_vault_certificate_permissions         = null # ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers"]
key_vault_key_permissions                 = null # ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "Decrypt", "Encrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge" ]
key_vault_secret_permissions              = null # ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"]

### AKS
cluster_name                              = "aks-disks"
private_cluster_enabled                   = false
kubernetes_version                        = "1.21.9"
network_plugin                            = "kubenet"
network_policy                            = "calico"
node_pools                                = [{
                                              name                  = "default"
                                              orchestrator_version  = "1.21.9"
                                              vm_size               = "Standard_E16s_v3"
                                              os_disk_size_gb       = null
                                              os_disk_type          = null
                                              vnet_name             = "infra"
                                              subnet_name           = "aks-subnet"
                                              node_count            = 1
                                              enable_auto_scaling   = false
                                              min_count             = null
                                              max_count             = null
                                              max_pods              = null
                                              availability_zones    = ["1", "2", "3"]
                                              enable_public_ip      = false
                                              ultra_ssd_enabled     = false
                                              labels                = {}
                                              taints                = []
                                              mode                  = "System"
                                            },
                                          ]