output "rhel_vm_name" {
  value = azurerm_virtual_machine.rhelvm.name
}

output "tls_private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}