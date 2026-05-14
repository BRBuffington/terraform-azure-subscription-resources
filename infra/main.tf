# Deploy all the resource groups required
# Additional Resource Groups can be added using the resource_groups map variable
resource "azurerm_resource_group" "this" {
  for_each = local.aggregated_resource_groups
  name     = each.key
  location = each.value.location

  # Get the solution tags and specific tags from the map
  # Yor will also automatically add the generic tags
  tags = merge(lookup(each.value, "tags", {}), try(local.aggregated_tags, {}))

  depends_on = [
    data.azurerm_subscription.current
  ]
}

# Let's get the tags from the subscription, so we don't have to repeat it in this composition
data "azurerm_subscription" "current" {
}
data "azurerm_subscription" "monitoringstore" {
  subscription_id = var.azure_provider_monitoringstore.subscription_id
}

# Subscription Contact for Security-related notifications
resource "azurerm_security_center_contact" "this" {
  email = "securityops@example.com"

  alert_notifications = true
  alerts_to_admins    = true

}
##-------------------------------------
#### Monitoring Additions
##-------------------------------------
data "azurerm_client_config" "current" {}

data "azuread_service_principal" "logged_in_app" {
  count          = var.logged_aad_app_objectId == null ? 0 : 1
  application_id = data.azurerm_client_config.current.client_id
}

module "monitor_action_groups" {
  source = "git::${MODULE_BASE}/terraform-azurerm-monitoring//modules/monitoring/monitor_action_group?ref=v3.2.2"
  providers = {
    azurerm = azurerm.monitoring
  }
  for_each               = local.monitoring.monitor_action_groups
  azure_provider_default = var.azure_provider_monitoringstore
  settings               = each.value
  resource_group_name    = each.value.resource_group_name
  tags                   = local.monitoring_tags

  depends_on = [
    azurerm_resource_group.this
  ]
}

module "monitor_activity_log_alert" {
  source = "git::${MODULE_BASE}/terraform-azurerm-monitoring//modules/monitoring/monitor_activity_log_alert?ref=v3.2.2"
  providers = {
    azurerm = azurerm.monitoring
  }
  for_each                 = local.monitoring.monitor_activity_log_alert
  azure_provider_default   = var.azure_provider_monitoringstore
  client_config            = local.client_config
  settings                 = each.value
  resource_group_name      = each.value.resource_group_name
  remote_objects           = local.remote_objects
  target_subscription_name = data.azurerm_subscription.current.display_name
  tags                     = local.monitoring_tags

  depends_on = [
    azurerm_resource_group.this
  ]
}

module "monitor_metric_alert" {
  source = "git::${MODULE_BASE}/terraform-azurerm-monitoring//modules/monitoring/monitor_metric_alert?ref=v3.2.2"
  providers = {
    azurerm = azurerm.monitoring
  }
  for_each                 = local.monitoring.monitor_metric_alert
  azure_provider_default   = var.azure_provider_monitoringstore
  client_config            = local.client_config
  settings                 = each.value
  resource_group_name      = each.value.resource_group_name
  remote_objects           = local.remote_objects
  target_subscription_name = data.azurerm_subscription.current.display_name
  tags                     = local.monitoring_tags

  depends_on = [
    azurerm_resource_group.this
  ]
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------