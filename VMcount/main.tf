provider "azurerm" {
  features {}
}

# variable "vmall" {
#   default = [
#     {
#       name      = "vm1"
#       rg        = "rg1"
#       sb        = "sb1"
#       sb_prefix = ["10.0.1.0/24"]
#     },
#     {
#       name      = "vm2"
#       rg        = "rg2"
#       sb        = "sb2"
#       sb_prefix = ["10.0.2.0/24"]
#     }
#   ]
# }

# variable "vmall" {
# default = [
#   {
#     name        = "vm1"
#     rg  = "rg1"
#     sb = "sb1"
#     sb_prefix = ["10.0.1.0/24"]
#       },
#   {
#     name        = "vm2"
#     rg  = "rg2"
#     sb = "sb2"
#     sb_prefix = ["10.0.2.0/24"]
#       }
# ]
# }
locals {
  count = 10
  vm_prefix = "VirtualMachine"
  rg_prefix = "ResourceGroup"
  prefix = "PowerApp"
}

# locals {
#   vm_all = {for idx, name in var.vm_names: 
#             name => {
#               "name" = name
#               rg  = var.rg_names[idx]
#               sn  = var.subnets[idx]
#               sn_prefix = [var.sn_prefixes[idx]]
#             }
#            }
# }


# locals {
#   vm       = var.vm_names
#   rg       = var.rg_names
#   vmrg     = zipmap(local.vm, local.rg)
#   vmsubnet = zipmap(local.vm, keys(var.subnets))
#   vmrgsb = { "rg" = var.rg_names
#               "subnet" = toset(keys(var.subnets))
#               "vm"     = toset(var.vm_names)
#   }
# }

# locals {
#   vm = var.vm_names
#   rg = var.rg_names
#   vmrg=[for k,v in zipmap(local.vm, local.rg):{
#     vm = k
#     rg = v
#   }]
# }


# var.mylist1 = ['name1','name2','name3']
# var.mylist2 = ['ip1','ip2','ip3']
# var.mylist3 = ['eip1','eip2','eip3']


# locals {
#   inventory_ini = <<EOL
# %{ for i, name in var.vm_names ~}
# ${name} ip-address=${var.mylist2[i]} eip-address=${var.mylist3[i]}
# %{ endfor ~}
# EOL
# }

# output "vmall" {
#   value = var.vmall
# }

# output "vmrgsb" {
#   value = local.vmrgsb.key.rg
# }

# locals {
#   vmrgsb  = var.vmrgsb
# }


# output "vmrg" {
#   value = local.vmrg
# }

# variable "vmrgsb" {
#   description = "(optional) describe your variable"
#   default = {
#     vm1 = {rg1 = {"sb1" = ["10.0.1.0/24"]}},
#     vm2 = {rg2 = {"sb2" = ["10.0.1.0/24"]}}
#   }
# }

# output "vmrgsb" {
#   value = local.vmrgsb
# }

resource "azurerm_resource_group" "rg" {
  count = local.count
  name     = "${local.prefix}RG${count.index+1}"
  location = var.location
}

data "azurerm_resource_group" "SharedRG" {
  name     = "SharedRG1"
  
}

resource "azurerm_virtual_network" "vnet" {
  name                = "${local.prefix}VNET"
  address_space       = ["10.2.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.SharedRG.name
}

resource "azurerm_subnet" "subnet" {
  count = local.count
  name                 = "${local.prefix}Subnet${count.index+1}"
  resource_group_name  = data.azurerm_resource_group.SharedRG.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [element(var.sn_prefixes, count.index+1)]
}

resource "azurerm_network_interface" "nic" {
  count =local.count
  name                = "${local.prefix}NIC${count.index+1}"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg[count.index].name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_windows_virtual_machine" "vm" {
  count =local.count
  name                = "${local.prefix}VM${count.index+1}"
  resource_group_name = azurerm_resource_group.rg[count.index].name
  location            = var.location
  size                = "Standard_B1ms"
  admin_username      = "adminuser"
  admin_password      = "Default@12345"
  network_interface_ids = [
    azurerm_network_interface.nic[count.index].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}