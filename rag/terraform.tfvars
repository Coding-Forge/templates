resource_group_name      = "my-resource-group"
vnet_name                = "my-vnet"
address_space            = ["10.0.0.0/16"]
subnet_name              = "my-subnet"
subnet2_name             = "my-subnet-2"
key_vault_name           = "my-key-vault"
storage_account_name     = "mystorageaccount"
cognitive_account_name   = "my-cognitive-account"
azopenai_sku_name        = "S0"
public_network_access    = "Enabled"
custom_sub_domain_name   = "mycustomsubdomain"
identity_type            = "SystemAssigned"
default_action           = "Allow"
bypass                   = "AzureServices"
environment              = "dev"
azd_env_name             = "my-azdo-env"
solution                 = "my-solution"
deployment = [{
    name = "gpt-4"
    model = {
        name = "gpt-4"
        version = "1106-Preview"
    }
    scale = {
        type = "Standard"
        capacity = 20
    }
    rai_policy_name = "gpt-4-rai-policy"
},
{
    name = "gpt-35-turbo"
    model = {
        name = "gpt-35-turbo"
        version = "1106"
    }
    scale = {
        type = "Standard"
        capacity = 20
    }
    rai_policy_name = "gpt-35-turbo-rai-policy"
}]

resource_name            = "my-resource"
form_rec_name            = "my-form-recognizer"
sku_name                 = "F0"
search_service_name      = "my-search-service"
search_service_sku       = "Basic"
roles                    = ["Search Index Data Contributor", "Search Index Data Reader", "Storage Blob Data Contributor", "Storage Blob Data Reader", "Cognitve Services OpenAI"]