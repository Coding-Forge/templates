
variable "resource_group_name" {
    description = "The name of the resource group"
    type        = string
}

variable "vnet_name" {
    description = "The name of the virtual network"
    type        = string
}

variable "address_space" {
    description = "The address space of the virtual network"
    type        = list(string)
}

variable "subnet_name" {
    description = "The name of the subnet"
    type        = string
}

variable "subnet2_name" {
    description = "The name of the second subnet"
    type        = string
}

variable "key_vault_name" {
    description = "The name of the Key Vault"
    type        = string
}

variable "storage_account_name" {
    description = "The name of the storage account"
    type        = string
}

variable "cognitive_account_name" {
    description = "The name of the cognitive account"
    type        = string
}

variable "azopenai_sku_name" {
    description = "The SKU name for the OpenAI cognitive account"
    type        = string
}

variable "public_network_access" {
    description = "Specifies whether public network access is allowed"
    type        = string
    default     = "Enabled"
}

variable "custom_sub_domain_name" {
    description = "The custom subdomain name for the cognitive account"
    type        = string
}

variable "identity_type" {
    description = "The type of identity to assign to the resource"
    type        = string
    default     = "SystemAssigned"
}

variable "default_action" {
    description = "The default action for network ACLs"
    type        = string
    default     = "Allow"
}

variable "bypass" {
    description = "Specifies which traffic can bypass the network ACLs"
    type        = string
    default     = "AzureServices"
}

variable "environment" {
    description = "The environment tag for the resources"
    type        = string
}

variable "azd_env_name" {
    description = "The Azure DevOps environment name"
    type        = string
}

variable "solution" {
    description = "The solution tag for the resources"
    type        = string
}

variable "deployment" {
    description = "A map of deployment configurations"
    type        = map(object({
        model = object({
            name    = string
            version = string
        })
        scale = object({
            type    = string
            capcity = number
        })
    }))
}

variable "resource_name" {
    description = "The name of the resource"
    type        = string
}

variable "form_rec_name" {
    description = "The name of the Form Recognizer cognitive account"
    type        = string
}

variable "sku_name" {
    description = "The SKU name for the Form Recognizer cognitive account"
    type        = string
}

variable "search_service_name" {
    description = "The name of the search service"
    type        = string
}

variable "search_service_sku" {
    description = "The SKU for the search service"
    type        = string
}

variable "roles" {
    description = "A set of roles to assign"
    type        = set(string)
}