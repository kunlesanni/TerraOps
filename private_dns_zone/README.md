module "blob_pdns_zone" {
  source = "./private_dns_zone"
  for_each = local.vnet_ids
  rg = "rg-vlz-connectivity-uks"
  pdns_zone = "guladnszone.myprivatezoen.com"
  vnet    = each.value
  vnet_id = each.key
  tags = {
    Environment = "Production"
    Owner = "ISD Cloud Platform"
    "Requested By" = "BAU"
    CreatedOn = formatdate("DD/MM/YYYY", timestamp())
    Terraform = "True"
  }
}
