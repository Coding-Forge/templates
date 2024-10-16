locals {
    private_endpoint_name = "${var.resource_name}-pe"
}

resource "random_integer" "priority" {
    min = 1000
    max = 9999

    keepers = {
        force_new = "${timestamp()}"
    }
}

resource "azurerm_private_endpoint" "private_endpoint" {
    count = length(var.subresource_names)

    name                = local.private_endpoint_name
    location            = data.azurerm_resource_group.rg.location
    resource_group_name = data.azurerm_resource_group.rg.name
    subnet_id           = data.azurerm_subnet.subnet.id

    private_service_connection {
        name                           = "${local.private_endpoint_name}-connection"
        private_connection_resource_id = data.azurerm_storage_account.storage_account.id
        subresource_names              = var.subresource_names
        is_manual_connection           = var.is_manual_connection
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
        