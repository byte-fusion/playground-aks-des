region              = "westeurope"
resource_group_name = "playground-aks-subnets"

### INFRA
vnet_name           = "infra"
vnet_address_spaces = ["10.100.0.0/16"]
vnet_subnets = [{
  name             = "aks-subnet1"
  vnet_name        = "infra"
  address_prefixes = ["10.100.1.0/24"]
  },
  {
    name             = "aks-subnet2"
    vnet_name        = "infra"
    address_prefixes = ["10.100.2.0/24"]
}]

### AKS
cluster_name            = "aks-subnets"
private_cluster_enabled = false
kubernetes_version      = "1.22.15"
network_plugin          = "kubenet"
network_policy          = "calico"

node_pools = [{
  name                   = "workersub1"
  orchestrator_version   = "1.22.15"
  vm_size                = "Standard_B4ms"
  enable_host_encryption = false
  os_disk_size_gb        = null
  os_disk_type           = null
  vnet_name              = "infra"
  subnet_name            = "aks-subnet1"
  node_count             = 1
  enable_auto_scaling    = false
  min_count              = null
  max_count              = null
  max_pods               = null
  availability_zones     = ["1", "2", "3"]
  enable_public_ip       = false
  ultra_ssd_enabled      = false
  labels                 = {}
  taints                 = []
  mode                   = "System"
  },
  {
  name                   = "workersub2"
  orchestrator_version   = "1.22.15"
  vm_size                = "Standard_B4ms"
  enable_host_encryption = false
  os_disk_size_gb        = null
  os_disk_type           = null
  vnet_name              = "infra"
  subnet_name            = "aks-subnet2"
  node_count             = 1
  enable_auto_scaling    = false
  min_count              = null
  max_count              = null
  max_pods               = null
  availability_zones     = ["1", "2", "3"]
  enable_public_ip       = false
  ultra_ssd_enabled      = false
  labels                 = {}
  taints                 = []
  mode                   = "System"
  },
]