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