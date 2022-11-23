variable "region" {
  description = "Region of the resource group."
  type        = string
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_spaces" {
  type = list(string)
}

variable "vnet_subnets" {
  description = "List of objects that will create subnets"
  type = list(object({
    name             = string
    vnet_name        = string
    address_prefixes = list(string)
  }))
  default = []
}

variable "key_vault_name" {
  type = string
}

variable "key_vault_randomize_name_suffix" {
  type    = string
  default = true
}

variable "key_vault_sku_tier" {
  type = string
}

variable "key_vault_disk_encryption_access_enabled" {
  type = bool
}

variable "key_vault_vm_access_enabled" {
  type = bool
}

variable "key_vault_soft_delete_retention_days" {
  type = number
}

variable "key_vault_purge_protection_enabled" {
  type = bool
}

variable "key_vault_enable_rbac" {
  type    = bool
  default = true
}

variable "key_vault_certificate_permissions" {
  type    = list(string)
  default = null
}

variable "key_vault_key_permissions" {
  type    = list(string)
  default = null
}

variable "key_vault_secret_permissions" {
  type    = list(string)
  default = null
}

variable "cluster_name" {
  type = string
}

variable "private_cluster_enabled" {
  type    = bool
  default = false
}

variable "kubernetes_version" {
  type = string
}

variable "node_count" {
  type    = number
  default = 1
}

variable "network_plugin" {
  type    = string
  default = "kubenet"
}

variable "network_policy" {
  type    = string
  default = "calico"
}

# variable "disk_encryption_set_id" {
#   type    = bool
#   default = false
# }

variable "node_pools" {
  type = list(object({
    name                   = string
    orchestrator_version   = string
    vm_size                = string
    enable_host_encryption = bool
    os_disk_size_gb        = number
    os_disk_type           = string
    vnet_name              = string
    subnet_name            = string
    node_count             = number
    enable_auto_scaling    = bool
    min_count              = number
    max_count              = number
    max_pods               = number
    availability_zones     = list(string)
    enable_public_ip       = bool
    ultra_ssd_enabled      = bool
    labels                 = map(string)
    taints                 = list(string)
    mode                   = string
  }))
}
