/*
  Create/Update the Network Watcher for each region
  We are doing a REST API call for backwards compatibility of existing network watchers. Existing NetworkWatchers will just be updated/ignored, and if it doesn't exist it will be created

  Do note there can only be 1 Network Watcher per Subscription/Region, so we cannot just create new network watchers and migrate resources.
  If an existing network watcher is already deployed with a non-microsoft default name, the deployment will fail.
*/
resource "null_resource" "network_watcher" {
  for_each = toset(local.network_watcher_regions)

  triggers = {
    "name" = "NetworkWatcher_${lower(each.key)}" # Re-trigger if the name changes
  }

  # REST API Doc: https://docs.microsoft.com/en-us/rest/api/network-watcher/network-watchers/create-or-update
  provisioner "local-exec" {
    command     = <<EOT
      # Let's check if we are logged in
      az account list-locations --output none

      # If not logged in, use the SP
      if ($LastExitCode -ne 0) {
        az login --service-principal -u $ENV:ARM_CLIENT_ID -p $ENV:ARM_CLIENT_SECRET --tenant 00000000-0000-0000-0000-000000000000
      }

      # Set the az context to the subscription
      az account set --subscription ${var.subscription_id}

      # Check if NetworkWatcherRG exist
      $CheckRG = $(az group exists -n NetworkWatcherRG)

      if ($CheckRG -ne "true"){
        az group create -l ${each.key} -n NetworkWatcherRG
      }

      $body = @{
        location = "${each.key}"
        properties = @{}
      } | ConvertTo-Json -Compress

      az rest --method PUT --headers 'Content-Type=application/json' --uri https://management.azure.com/subscriptions/${var.subscription_id}/resourceGroups/NetworkWatcherRG/providers/Microsoft.Network/networkWatchers/NetworkWatcher_${lower(each.key)}?api-version=2021-08-01 --body $body
    EOT
    interpreter = ["pwsh", "-Command"]
  }
}

# Network Security Groups/NSGs
module "network_security_group" {
  for_each = merge(var.default_network_security_groups, var.network_security_groups)
  source   = "git::${MODULE_BASE}/terraform-azurerm-spoke//modules/nsg?ref=v2.0.0"

  name                   = each.key
  location               = each.value.location
  nsg_flow_logs_settings = lookup(each.value, "nsg_flow_logs_settings", null) # null = use module defaults
  rules                  = lookup(each.value, "rules", null)                  # null = use module defaults
  resource_group_name    = lookup(each.value, "resource_group_name", format("rg-network-%s", reverse(split("-", each.key))[0]))

  # Get the solution tags and specific tags from the maps
  # Yor will also automatically add the generic tags
  tags = merge(lookup(each.value, "tags", {}), try(local.aggregated_tags, {}))

  depends_on = [
    azurerm_resource_group.this,
    null_resource.network_watcher
  ]
}

# Route Tables/UDRs
module "user_defined_routing" {
  for_each = merge(var.default_route_tables, var.route_tables)
  source   = "git::${MODULE_BASE}/terraform-azurerm-spoke//modules/udr?ref=v2.0.0"

  name                = each.key
  location            = each.value.location
  routes              = lookup(each.value, "routes", {})
  resource_group_name = lookup(each.value, "resource_group_name", format("rg-network-%s", reverse(split("-", each.key))[0]))

  # Get the solution tags and specific tags from the maps
  # Yor will also automatically add the generic tags
  tags = merge(lookup(each.value, "tags", {}), try(local.aggregated_tags, {}))

  depends_on = [
    azurerm_resource_group.this
  ]
}

# VNET and Subnets
module "spoke" {
  for_each = var.vnets
  source   = "git::${MODULE_BASE}/terraform-azurerm-spoke//modules/spoke?ref=v2.0.0"

  virtual_network_name = each.key
  resource_group_name  = each.value.resource_group_name
  location             = each.value.location
  address_space        = each.value.address_space

  # If passed on the variable map, use that. If not try to get the DNS servers based off the priority. If all else fails, use the static list with East US 2 as primary
  dns_servers            = lookup(each.value, "dns_servers", try(local.dns_servers[each.value.location], ["172.28.33.4", "172.28.33.5", "172.28.33.132", "172.28.33.133"]))
  peer_to_hub            = lookup(each.value, "peer_to_hub", null)
  add_route_to_hubgw     = lookup(each.value, "add_route_to_hubgw", null)
  add_route_to_hubtrust  = lookup(each.value, "add_route_to_hubtrust", null)
  create_virtual_network = lookup(each.value, "create_virtual_network", null)
  subnets                = lookup(each.value, "subnets", {})

  /*
   This is used to populate the udr-hubgw-<region alias> and udr-hubtrust-<other region alias> if add_route_to_hubgw/hubtrust are true
   Since we have the default gateway in this composition, we can pass it to the module so it doesn't need to do a data lookup
   If not set, the module will query the udr-tohub-<region alias> for the default gateway

   We need to use `try` to ensure proper input type/structure is passed
  */
  hub_default_gateway = try(each.value.hub_default_gateway, local.hub_default_gateways[lower(reverse(split("-", each.key))[0])].ip, null)

  # Get the solution tags and specific tags from the maps
  # Yor will also automatically add the generic tags
  tags = merge(lookup(each.value, "tags", {}), try(local.aggregated_tags, {}))

  providers = {
    azurerm     = azurerm
    azurerm.hub = azurerm.hub
  }

  depends_on = [
    azurerm_resource_group.this,
    module.network_security_group,
    module.user_defined_routing
  ]
}