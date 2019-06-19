#Define backend
terraform {
	backend "azurerm" {} 
}

# Configure the Azure Provider
provider "azurerm" {
  
  subscription_id = "${var.subscription_id}"
	client_id = "${var.client_id}"
	client_secret = "${var.client_secret}"
	tenant_id = "${var.tenant_id}"

}

resource "azurerm_resource_group" "Trial" {
  name     = "${var.resource_group}"
  location = "Central US"
}

resource "azurerm_app_service_plan" "Trial" {
  name                = "${var.env_name}-${var.app_name}-appservice-plan"
  location            = "${azurerm_resource_group.Trial.location}"
  resource_group_name = "${azurerm_resource_group.Trial.name}"
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "Trial" {
  name                = "${var.env_name}-${var.app_name}-app-service"
  location            = "${azurerm_resource_group.Trial.location}"
  resource_group_name = "${azurerm_resource_group.Trial.name}"
  app_service_plan_id = "${azurerm_app_service_plan.Trial.id}"

  site_config {
    linux_fx_version         = "${var.java_version}"
    scm_type                 = "LocalGit"
  }

}

/*data "azurerm_app_service" "Trial" {
  name                = "search-app-service"
  resource_group_name = "search-service"
}*/

output "app_service_name" {
  value = "${azurerm_app_service.Trial.name}"
}


