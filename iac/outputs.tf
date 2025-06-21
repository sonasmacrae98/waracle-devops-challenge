output "public_ip_address" {
  description = "The public IP address of the web VM"
  value       = azurerm_public_ip.web_public_ip.ip_address
}
