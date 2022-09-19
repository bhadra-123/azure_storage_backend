locals {
  resource_prefix = "${var.environment}-${var.location_short}"
  Owner       = var.Owner
  Reason      = var.Reason
  Environment = var.Environment
  common_tags = {
    Owner       = local.Owner
    Reason      = local.Reason
    Environment = local.Environment
  }
}

