# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "random_integer" "ri" {
  min = 10000
  max = 99999
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = ${var.resource_group_name}
  location = ${var.resource_group_location}
}

resource "azurerm_app_service_plan" "appsp" {
  name                = ${var.app_service_plan_name}
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  kind                = "Linux"
  reserved            = "true"
  sku {
    tier = "Standard"
    size = "F1"
  }
}

resource "azurerm_linux_web_app" "webapp" {
  name                = ${var.app_service_name}
  resource_group_name = ${var.resource_group_name}
  location            = ${var.resource_group_location}
  service_plan_id     = azurerm_app_service_plan.appsp.id
  https_only          = true
  site_config {
    application_stack {
      dotnet_version = "6.0"
    }
    always_on = false
  }
  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${var.sql_server_name};User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}



#  Deploy code from a public GitHub repo
resource "azurerm_app_service_source_control" "sourcecontrol" {
  app_id                 = azurerm_linux_web_app.webapp.id
  repo_url               = ${var.repo_url}
  branch                 = "main"
  use_manual_integration = true
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = ${var.sql_server_name}
  resource_group_name          = ${var.resource_group_name}
  location                     = ${var.resource_group_location}
  version                      = "12.0"
  administrator_login          = ${var.sql_admin_login}
  administrator_login_password = ${var.sql_admin_password}
}

resource "azurerm_mssql_database" "sqldatabase" {
  name           = ${var.sql_database_name}
  server_id      = azurerm_mssql_server.sqlserver.id
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  sku_name       = "S0"
  zone_redundant = false

  tags = {
    foo = "bar"
  }
}

resource "azurerm_mssql_firewall_rule" "sqlrule" {
  name             = ${var.firewall_rule_name}
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}
