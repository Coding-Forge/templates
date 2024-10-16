locals {
    network_interface_name = "${var.resource_name}-ni"
}

resource "azurerm_network_interface" "network_interface" {
    name                = local.network_interface_name
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "${local.network_interface_name}-ipconfig"
        subnet_id                     = data.azurerm_subnet.subnet.id
        private_ip_address_allocation = var.private_ip_address_allocation
    }

    tags = {
        environment = var.environment
        azd-env-name = var.azd_env_name
        solution = var.solution
    }

    lifecycle {
        ignore_changes = [
            tags
        ]
    }
}