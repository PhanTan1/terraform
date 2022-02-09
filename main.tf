provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg_lab06"  {
  name     = "my-resources-group-lab06.name"
  location = "West Europe"
}

module "linuxservers" {
  source              = "Azure/compute/azurerm"
  resource_group_name = azurerm_resource_group.rg_lab06.name
  vm_os_simple        = "UbuntuServer"
  public_ip_dns       = ["my-nginx-servertan"] // change to a unique name per datacenter region
  vnet_subnet_id      = module.network.vnet_subnets[0]

  depends_on = [azurerm_resource_group.rg_lab06]

   vm_hostname                      = "mylinuxvm"
  nb_public_ip                     = 1
  remote_port                      = "22"
  nb_instances                     = 1
  vm_os_publisher                  = "Canonical"
  vm_os_offer                      = "UbuntuServer"
  vm_os_sku                        = "18.04-LTS"

  boot_diagnostics                 = true
  delete_os_disk_on_termination    = true
  nb_data_disk                     = 1
  data_disk_size_gb                = 20
  data_sa_type                     = "Standard_LRS"
  enable_ssh_key                   = true
  ssh_key_values                   = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKXakUEaLOjvmyFlFnM1VYUbKCRCmFkZvLoOQdi5qhOO6BOeBKkBMcrIgUagONA0qwcxiRRmD44GOoL9s+Y0fNF2Ts2Snzyx1JL2VDUesVwLiwoag7n1UYUInqqghpMiZvorRD9Hgi0IXtWYIE5UkdidL7n5hLd5F3as1xAAvowmBPxjd/3Xfsfs0XrHsgC1v09FW0cZWO/U+6e30O835mME/IXNf+NoZzkFS9wHEFYxOvmGb9ea0JrM5H6eX7WTYNA+w83aTSmm9rYEUDvIfEegnk8iVScij79F6pPuMS302oTFj1qe7Ke/OcnRTzJCgNDQnRpn3Y+bzhksRdWn2jSeKx30ZXmiyea3T/OQoRDM5juJdB40EkNUp6weuvIS2Z4o9JdvIwCN95Ql46oa29YGi1OV+982SS3vb6HlETrXZ4HXlYSSgnHD3jGruSss+Y+odNmv5RG3D525rDXicS86gBRrokfxeH+7iSF2RbW2wdTVC9vnaLi5qQkFJIJd0= training\\student@ROME3-4"]

  vm_size                          = "Standard_D4s_v3"
  delete_data_disks_on_termination = true

  tags = {
    environment = "dev"
    costcenter  = "it"
  }

  enable_accelerated_networking = true
}



module "network" {
  source              = "Azure/network/azurerm"
  resource_group_name = azurerm_resource_group.rg_lab06.name
  subnet_prefixes     = ["10.0.1.0/24"]
  subnet_names        = ["subnet1"]

  depends_on = [azurerm_resource_group.rg_lab06]
}


