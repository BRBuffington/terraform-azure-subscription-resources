locals {
  # Let's get all unique resource groups to provision within the vnets map
  unique_resource_groups_vnets = distinct([
    for vnet in var.vnets : {
      name     = vnet.resource_group_name,
      location = vnet.location
    }
  ])

  # Let's get all unique resource groups to provision within the network_security_groups & default_network_security_groups maps
  unique_resource_groups_nsgs = distinct([
    for nsg in merge(var.network_security_groups, var.default_network_security_groups) : {
      name     = nsg.resource_group_name,
      location = nsg.location
    } if try(nsg.location, "") != "" && try(nsg.resource_group_name, "") != ""
  ])

  # Let's get all unique resource groups to provision within the default_route_tables & route_tables maps
  unique_resource_groups_udrs = distinct([
    for udr in merge(var.default_route_tables, var.default_route_tables) : {
      name     = udr.resource_group_name,
      location = udr.location
    } if try(udr.location, "") != "" && try(udr.resource_group_name, "") != ""
  ])

  # We're going to dynamically get the resource groups to provision, and merge it into 1 local for resource group provisioning
  aggregated_resource_groups = merge(
    /*
      We're creating a normalized map to be used for the RG creation

      This will loop through the unique maps and using distinct so don't get duplicates. The output format will look like this:
        + rg-sample-sb-eus2           = {
            + location = "eastus2"
          }
        + rg-network-cus          = {
            + location = "centralus"
          }
        + rg-network-eus2         = {
            + location = "eastus2"
          }
        + rg-test-cus                 = {
            + location = "centralus"
          }
        + rg-test-eus2                = {
            + location = "eastus2"
          }
    */
    {
      for rg in toset(distinct(concat(
        local.unique_resource_groups_vnets,
        local.unique_resource_groups_nsgs,
        local.unique_resource_groups_udrs
        ))) : rg.name => {
        location = rg.location
      }
    },

    # Add maps that doesn't need transformation
    var.default_resource_groups,
    var.resource_groups
  )

  # Get all the locations where the VNETs will be deployed, so we can enable the NetworkWatcher in that region
  network_watcher_regions = distinct(concat(
    [for vnet in var.vnets : vnet.location],
    [for nsg in merge(var.network_security_groups, var.default_network_security_groups) : nsg.location]
  ))

  # Get all the regions of the HUB by checking the UDR and VNET region aliases
  hub_region_aliases = distinct(concat(
    [for vnet_name, vnet_info in var.vnets : reverse(split("-", vnet_name))[0]],
    [for udr_name, udr_info in merge(var.route_tables, var.default_route_tables) : reverse(split("-", udr_name))[0]],
  ))

  # Get the default gateways from the udr-tohub-<region alias>
  hub_default_gateways = {
    for k, v in var.default_route_tables : reverse(split("-", k))[0] => {
      ip = v.routes["DefaultGateway"].next_hop_in_ip_address
    } if length(regexall(".*tohub.*", k)) > 0
  }

  # Get the specific tags from the subscription
  lookup_lz_tags = tomap({
    for tag, value in data.azurerm_subscription.current.tags : tag => value if contains([
      "BusinessOwner",
      "EnvironmentType",
      "Lifecycle",
      "Product"
  ], tag) })

  aggregated_tags = merge(
    try(var.tags, {}),
    local.lookup_lz_tags
  )

  # Get the DNS servers with region priority
  dns_servers = {
    "eastus2"   = ["172.28.33.4", "172.28.33.5", "172.28.33.132", "172.28.33.133"]
    "centralus" = ["172.28.33.132", "172.28.33.133", "172.28.33.4", "172.28.33.5"]
  }
  ##-------------------------------------
  #### Monitoring Additions
  ##-------------------------------------

  # Generate ID manually instead of using data to simplify cross-subscription assignment
  log_analytics_workspace_id = "/subscriptions/${var.target_log_analytics_workspace.subscription_id}/resourceGroups/${var.target_log_analytics_workspace.rg}/providers/Microsoft.OperationalInsights/workspaces/${var.target_log_analytics_workspace.name}"

  client_config = var.client_config == {} ? {
    client_id               = data.azurerm_client_config.current.client_id
    landingzone_key         = var.current_landingzone_key
    logged_aad_app_objectId = local.object_id
    logged_user_objectId    = local.object_id
    object_id               = local.object_id
    subscription_id         = data.azurerm_client_config.current.subscription_id
    tenant_id               = data.azurerm_client_config.current.tenant_id
  } : map(var.client_config)

  object_id = coalesce(var.logged_user_objectId, var.logged_aad_app_objectId, try(data.azurerm_client_config.current.object_id, null), try(data.azuread_service_principal.logged_in_app.0.object_id, null))

  monitoring = merge({
    log_analytics_storage_insights             = try(var.monitoring.log_analytics_storage_insights, {})
    monitor_autoscale_settings                 = try(var.monitoring.monitor_autoscale_settings, {})
    monitor_action_groups                      = try(var.monitoring.monitor_action_groups, {})
    monitor_metric_alert                       = try(var.monitoring.monitor_metric_alert, {})
    monitor_activity_log_alert                 = try(var.monitoring.monitor_activity_log_alert, {})
    monitor_alert_processing_rule_action_group = try(var.monitoring.monitor_alert_processing_rule_action_group, {})
    monitor_alert_processing_rule_suppression  = try(var.monitoring.monitor_alert_processing_rule_suppression, {})
  }, var.monitoring)

  monitored_subscription_target_displayname = data.azurerm_subscription.current.display_name

  monitoring_tags = merge({
    "MonitoredSubscription" = local.monitored_subscription_target_displayname
  }, var.tags)
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------
