output "resource_group_name" {
  value = azurerm_resource_group.resource_group.name
}

output "storage_account_name" {
  value = azurerm_storage_account.blob_storage_account.name
}

