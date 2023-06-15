output "web_url" {
  value       = "azurem_linux_web_app.app.default_hostname"
  sensitive   = true
  description = "description"
  depends_on  = []
}

output "webapp_ips" {
  value       = "azurem_linux_web_app.app.outbound_ip_addresses"
  sensitive   = true
  description = "description"
  depends_on  = []
}

