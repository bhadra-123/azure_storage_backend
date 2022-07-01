#--------
# LOCALS
#--------

client_name    = "origin"
environment    = "dev"
location_short = "eu"
creator        = "bhadra.mangunuru@gmail.com"

#----------------
# RESOURCE GROUP
#----------------

resource_group_name = "terraform_backend_rg"
location            = "East US"

#----------------
# BLOB CONTAINER
#----------------


naming_suffix                         = "origin-dev-eu"
blob_storage_account_name             = "terraformbackend"
blob_storage_account_tier             = "Standard"
blob_storage_account_replication_type = "LRS"
blob_storage_account_kind             = "StorageV2"
blob_storage_account_is_hns_enabled   = true
blob_storage_container_names          = ["blob-container-1", "blob-container-2"]
blob_storage_container_access_type    = "private"