# IP publique de la VM
output "vm_public_ip" {
  description = "Adresse IP publique de la VM Ansible"
  value       = azurerm_public_ip.public_ip.ip_address
}

# Nom de la VM
output "vm_name" {
  description = "Nom de la VM Ansible"
  value       = azurerm_linux_virtual_machine.vm.name
}

# Utilisateur SSH
output "admin_username" {
  description = "Utilisateur utilisé pour la connexion SSH"
  value       = azurerm_linux_virtual_machine.vm.admin_username
}

# ID du subnet
output "subnet_id" {
  description = "ID du subnet dédié à la VM Ansible"
  value       = azurerm_subnet.subnet.id
}

# ID du NSG
output "nsg_id" {
  description = "ID du NSG de la VM Ansible"
  value       = azurerm_network_security_group.nsg.id
}

# Clé privée SSH
output "ssh_private_key" {
  description = "Clé privée SSH permettant la connexion à la VM"
  value       = tls_private_key.private_key.private_key_pem
  sensitive   = true
}
