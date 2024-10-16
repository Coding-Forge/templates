terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.101.0"
    }
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
}

data "azurerm_subscription" "current" {}
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  address_space       = var.address_space
}

data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

data "azurerm_subnet" "subnet2" {
  name                 = var.subnet2_name
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
}   

data "azurerm_storage_account" "storage_account" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

resource "random_integer" "priority" {
  min = 1000
  max = 9999

    keepers = {
        force_new = "${timestamp()}"
    }
}

resource "azurerm_cognitive_account" "azopenai" {
    name                = var.cognitive_account_name
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    sku_name            = var.azopenai_sku_name
    kind                = "OpenAI"
    public_network_access = var.public_network_access
    custom_sub_domain_name = var.custom_sub_domain_name

    identity {
        type = var.identity_type
    }

    network_acls {
        default_action = var.default_action
        bypass         = var.bypass
    }

    tags = {
        environment = var.environment
        azd-env-name = var.azd_env_name
        solution = var.solution
    }

    lifecycle {
        ignore_changes = [
            tags,
            customer_managed_key
        ]
    }
}

resource "azurerm_cognitive_deployment" "deployment" {
    for_each = { for key, value in var.deployment : deployment.name => deployment }
    name                = each.key
    cognitive_account_id = azurerm_cognitive_account.azopenai.id

    model {
        format = var.kind
        name = each.value.model.name
        version = each.value.model.version
    }
    scale {
        type = each.value.scale.type
        capcity = each.value.scale.capcity
    }
    lifecycle {
        # ignore_changes = [ tags]
    }
}

module "openai_pe" {
  source = "./modules/azurerm/resource/privateendpoint"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  resource_name = var.resource_name
  resource_id = azurerm_cognitive_account.azopenai.id
  private_endpoint_subnet_id = data.azurerm_subnet.subnet.id
  private_endpoint_name = "${var.resource_name}-pe"
}

resource "azurerm_cognitive_account" "form-rec" {
    name                = var.cognitive_account_name
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    sku_name            = var.sku_name
    kind                = "FormRecognizer"
    public_network_access = var.public_network_access
    custom_sub_domain_name = var.custom_sub_domain_name

    identity {
        type = var.identity_type
    }

    network_acls {
        default_action = var.default_action
        # bypass         = var.bypass
    }

    tags = {
        environment = var.environment
        azd-env-name = var.azd_env_name
        solution = var.solution
    }

    lifecycle {
        ignore_changes = [
            tags,
            customer_managed_key
        ]
    }
}

module "form-rec-pe" {
  source = "./modules/azurerm/resource/privateendpoint"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  resource_name = var.form_rec_name
  resource_id = azurerm_cognitive_account.form-rec.id
  private_endpoint_subnet_id = data.azurerm_subnet.subnet.id
  private_endpoint_name = "${var.resource_name}-pe"
  is_manual_connection = false
  subresource_names = ["account"]
}

resource "azurerm_search_service" "search" {
    name                = var.search_service_name
    resource_group_name = data.azurerm_resource_group.rg.name
    location            = data.azurerm_resource_group.rg.location
    sku                 = var.search_service_sku

    public_network_access = var.public_network_access
    authentication_failure_mode = "http401WithBearerChallenge"

    timeouts {
        create = "60m"
        read = "10m"
        # update = "30m"
        # delete = "30m"
    }

    identity {
        type = var.identity_type
    }

    lifecycle {
        ignore_changes = [
            tags,
            customer_managed_key
        ]
    }

    tags = {
        environment = var.environment
        azd-env-name = var.azd_env_name
        solution = var.solution
    }
}

module "search-pe" {
  source = "./modules/azurerm/resource/privateendpoint"
  resource_group_name = data.azurerm_resource_group.rg.name
  location = data.azurerm_resource_group.rg.location
  resource_name = var.search_service_name
  resource_id = azurerm_search_service.search.id
  private_endpoint_subnet_id = data.azurerm_subnet.subnet.id
  private_endpoint_name = "${var.resource_name}-pe"
  is_manual_connection = false
  subresource_names = ["searchService"]
}

resource "azurerm_role_assignment" "role_assignment" {
  scope                = data.azurerm_resource_group.rg.id
  for_each = toset(var.roles)
  role_definition_name = each.key
  principal_id         = data.azurerm_subscription.current.client_id
}
