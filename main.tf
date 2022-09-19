#----------------
# RANDOM STRING
#----------------
resource "random_string" "myrandom" {
  length  = 8
  upper   = false
  special = false
  numeric = true
  lower   = true
}

#----------------
# RESOURCE GROUP
#----------------

resource "azurerm_resource_group" "resource_group" {
  name     = "${local.resource_prefix}-${var.resource_group_name}"
  location = var.location
  tags     = local.common_tags
}

#-----------------
# STORAGE ACCOUNT
#-----------------

resource "azurerm_storage_account" "blob_storage_account" {
  depends_on = [
    azurerm_resource_group.resource_group
  ]
  name                     = "${local.resource_prefix}-${var.blob_storage_account_name}${random_string.myrandom.id}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.blob_storage_account_tier
  account_replication_type = var.blob_storage_account_replication_type
  account_kind             = var.blob_storage_account_kind
  is_hns_enabled           = var.blob_storage_account_is_hns_enabled
  tags                     = local.common_tags
}

#----------------
# BLOB CONTAINER
#----------------

resource "azurerm_storage_container" "blob_storage_container" {
  depends_on = [
    azurerm_storage_account.blob_storage_account
  ]
  count                 = length(var.blob_storage_container_names)
  name                  = "${local.resource_prefix}-${var.blob_storage_container_names[count.index]}"
  storage_account_name  = azurerm_storage_account.blob_storage_account.name
  container_access_type = var.blob_storage_container_access_type
}