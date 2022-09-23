#  variable "vm_names" {
#     default = [
#     "vm1",
#     "vm2",
#     "vm3",
#     "vm4",
#     "vm5"
# ]
#  }

#  variable "rg_names" {
#     default = [
#     "rg1",
#     "rg2",
#     "rg3",
#     "rg4",
#     "rg5"
# ]
#  }

#  variable "subnets" {
#     default = [
#     "sn1",
#     "sn2",
#     "sn3",
#     "sn4",
#     "sn5"
# ]
#  }


variable "location" {
  type        = string
  description = "(optional) describe your variable"
  default     = "uk south"
}

variable "shared_rg" {
  type = string
  description = "(optional) describe your variable"
  default = "SharedResourceGroup"
}

variable "vnet" {
  type = string
  description = "(optional) describe your variable"
  default = "HubVNET"
}

# variable "vmrgsb" {
#   description = "(optional) describe your variable"
#   default = {
#     vm1 = {rg1 = {"sb1" = []}},
#     vm2 = {rg2 = {"sb2" = []}}
#   }
# }

# variable "vmrgsb" {
#   description = "(optional) describe your variable"
#   default = {
#     vm1 = {rg = {"subnet" = ["10.0.1.0/24"]}}
#     vm2 = {rg2 = {"sb2" = ["10.0.1.0/24"]}}
#   }
# }

# variable "vmrgsb" {
#   description = "(optional) describe your variable"
#   default = {
#     vm = "vm1",
#     rg = rg1,
#     sb = {"sb2" = ["10.0.1.0/24"]}}
#   }


# variable "vmall" {
#   type = list(object({
#     name        = string
#     rg  = string
#     sb = string
#     sb_prefix = list
#   }))
# }

variable "vmall" {
default = [
  {
    name        = "vm1"
    rg  = "rg1"
    sb = "sb1"
    sb_prefix = ["10.0.1.0/24"]
      },
  {
    name        = "vm2"
    rg  = "rg2"
    sb = "sb2"
    sb_prefix = ["10.0.2.0/24"]
      }
]
}

# variable "vm_names" {
#   description = "(optional) describe your variable"
#   default = [
#     "ServiceVM1",
#     "ServiceVM2",
#     "ServiceVM3",
#     "ServiceVM4",
#     "ServiceVM5",
#     "ServiceVM6",
#     "ServiceVM7",
#     "ServiceVM8",
#     "ServiceVM9",
#     "ServiceVM10"
#   ]
# }

# variable "rg_names" {
#   description = "(optional) describe your variable"
#   default = [
#     "RG1",
#     "RG2",
#     "RG3",
#     "RG4",
#     "RG5",
#     "RG6",
#     "RG7",
#     "RG8",
#     "RG9",
#     "RG10"
#   ]
# }

# variable "subnets" {
#   description = "(optional) describe your variable"
#     default = {
#     subnet1  = "10.0.1.0/24"
#     subnet2  = "10.0.2.0/24"
#     subnet3  = "10.0.3.0/24"
#     subnet4  = "10.0.4.0/24"
#     subnet5  = "10.0.5.0/24"
#     subnet6  = "10.0.6.0/24"
#     subnet7  = "10.0.7.0/24"
#     subnet8  = "10.0.8.0/24"
#     subnet9  = "10.0.9.0/24"
#     subnet10 = "10.0.10.0/24"
#   }
# }
