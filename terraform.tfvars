#--------
# LOCALS
#--------

Owner       = "bhadrareddy.origin@gmail.com"
Reason      = "Ticket-12345"
Environment = "Dev"

#----------------
# RESOURCE GROUP
#----------------

resource_group_name = "terraform_backend_rg"
location            = "East US"

#----------------
# BLOB CONTAINER
#----------------

blob_storage_account_name             = "terraformbackend"
blob_storage_account_tier             = "Standard"
blob_storage_account_replication_type = "LRS"
blob_storage_account_kind             = "StorageV2"
blob_storage_account_is_hns_enabled   = true
blob_storage_container_names          = ["blob-container-1", "blob-container-2"]
blob_storage_container_access_type    = "private"