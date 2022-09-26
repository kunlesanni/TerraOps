variable "location" {
    type = string
    default = "uk south"
    }


variable "rg_names" {
  description = "(optional) describe your variable"
  default = [
    "RG1",
    "RG2",
    "RG3",
    "RG4",
    "RG5",
    "RG6",
    "RG7",
    "RG8",
    "RG9",
    "RG10"
  ]
}

# variable "subnets" {
#   description = "(optional) describe your variable"

#   default = {
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

variable "subnets" {
  description = "(optional) describe your variable"

  default = [
    "subnet1",
    "subnet2",
    "subnet3",
    "subnet4",
    "subnet5",
    "subnet6",
    "subnet7",
    "subnet8",
    "subnet9",
    "subnet10"
  ]
}

variable "sn_prefixes" {
  description = "(optional) describe your variable"

  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24"
  ]
}