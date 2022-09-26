variable "location" {
    type = string
    default = "uk south"
    }

variable "sn_prefixes" {
  description = "(optional) describe your variable"

  default = [
    "10.2.1.0/24",
    "10.2.2.0/24",
    "10.2.3.0/24",
    "10.2.4.0/24",
    "10.2.5.0/24",
    "10.2.6.0/24",
    "10.2.7.0/24",
    "10.2.8.0/24",
    "10.2.9.0/24",
    "10.2.10.0/24"
  ]
}