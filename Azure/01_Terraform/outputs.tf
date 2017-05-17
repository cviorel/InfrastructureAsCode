# IP address outputs

output "azure-ips" {
  value = "${join(",", azurerm_network_interface.cluster.*.private_ip_address)}"
}

output "azure-public-ips" {
  value = "${join(",", azurerm_public_ip.cluster.*.ip_address)}"
}
