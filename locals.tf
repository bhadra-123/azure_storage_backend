locals {
  resource_prefix = "${var.client_name}-${var.environment}-${var.location_short}"
  client_name     = var.client_name
  environment     = var.environment
  creator         = var.creator
  location        = var.location

  common_tags = {
    client_name = lower(local.client_name)
    environment = lower(local.environment)
    creator     = lower(local.creator)
    location    = lower(local.location)
  }
}

