#--------
# LOCALS
#--------

Owner       = "bhadrareddy.origin@gmail.com"
Reason      = "ticket-12345"
location_short = "eu"

#----------------
# RESOURCE GROUP
#----------------

resource_group_name = "terraform-backend-rg"
location            = "East US"

#----------------
# BLOB CONTAINER
#----------------

blob_storage_account_name             = "storage"
blob_storage_account_tier             = "Standard"
blob_storage_account_replication_type = "LRS"
blob_storage_account_kind             = "StorageV2"
blob_storage_account_is_hns_enabled   = true
blob_storage_container_names          = ["blob-container"]
blob_storage_container_access_type    = "private"

