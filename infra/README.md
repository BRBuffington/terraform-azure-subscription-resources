<!--#
    # Generate README using terraform-docs: https://github.com/terraform-docs/terraform-docs
    # Install using: choco install terraform-docs
    #
    # Run the following to generate the README.md (inside the infra/ dir):
    #   `terraform-docs markdown .`
    #   `terraform-docs markdown . --recursive` (if the composition contains sub-modules - modules/ dir)
-->
<!--#
Comments:
07/16/2024 -- DSloyer Updated Monitoring module to 3.2.0 to allow null values for action group in alert creation.
This allows no actions so that alert processing can be created to generate notifications or suppress notifications.  Actions are not explicitly bound to monitoring alert.
-->
## Introduction
The SS-Azure-SubacriptionResources composition is intended to deploy all Subscription requirements we are pre-requisites for the child resource deployments that will follow.

This includes:
* Infrastructure MVP monitoring per subscription, 
* Spoke Vnets and required subnets,
*  nsg's, 
*  udr's, 
*  network watcher, 
*  and resource groups

NOTE:  
* Current terraform-azurerm-monitoring module is v3.1.0
* Current TF provider version is 1.5.1
* Current Azurerm provider version is 3.61.0
## Subscription Monitoring Requirements
### Monitoring Reference Docs
* Resource types and health checks in Azure resource health:
  https://learn.microsoft.com/en-us/azure/service-health/resource-health-checks-resource-types
* Resource impact from Azure outages
  https://learn.microsoft.com/en-us/azure/service-health/impacted-resources-outage
* Resource impact from Azure security incidents
  https://learn.microsoft.com/en-us/azure/service-health/impacted-resources-security
* Resource Name Rules
  https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules
  name character limit is 260 > cannot end with space or period
### Pre-reqs for monitoring infrastructure mvp deployments
* Action groups for Infrastructure Email Alerts
  * It-mgmt-tst and app-mgmt-prd subscription monitoring deployments must be deployed first.  These subscriptions will contain the Infrastructure Monitoring action groups.
* Resource groups "rg-monitoringinfra-tst-eus2","rg-monitoringinfra-prd-eus2", (in each subscription)"rg-inframon-eus2", and "rg-inframon-cus" must be pre-deployed to contain monitoring rules and action groups.
* Action groups and Metrics alert rules will be centralized in IT-MGMT-PRD as much as possible.
  
### Alert Rule Naming
Metric Alert Rules and Activity Log Alert Rules are named dynamically based on the config requested as of terraform-azurerm-monitoring v3.0.0.

Names are built programatically with option to add custom string to name by including mala_name or mma_name in tfvars.  Alert rule names are forced to all lowercase.

Examples:
```
with custom mala_name in tfvars = "db" >  

Alert Rule Name = "mala-infra-db-databases-resourcehealth-app-mgmt-tst"

 

without custom mala_name provided in tfvars >

Alert Rule Name = "mala-infra-virtualmachines-resourcehealth-app-mgmt-tst"

 

Metric Alert Rule Name = 
*(you're gonna hate this, but it's very functional to search and identify alert rules at different scope [subscription, resource_group, resource])*

"mma-infra-virtualmachines-percentage-cpu-average-greaterthan-95-app-mgmt-tst"
```
### ServiceHealth
Each subscription will have a ServiceHealth Alert Rule deployed monitoring all resource types for Azure Backend Service availability.  The target scope is all services in the current subscription of each Alert Rule.

### ResourceHealth
At minimum, resource "instances" of the following resource types will be monitored and alert cloudops@example.com for health changes:
* Virtual Machines
* SQL Databases
* Log Analytics Workspaces
* Storage Accounts

The following resource health alerts should be deployed in Subscriptions where they exist:
* Kubernetes Services (if deployed)
* Azure Keyvaults (if deployed) ** Requires one alert rule per Keyvault
* Azure Data Factories (if deployed)

### Important Deployment Notes
For all PRD/TST subscriptions, Alert Rules and Action groups are centralized in, and deployed to >> IT-MGMT-PRD subscription.  
  * This is the reason an azure_provider_monitoringstore is defined > requires a connection to IT-MGMT-PRD at runtime to store alerts in this subscription.

Key changes for a new Monitoring in PRD/TST Subscriptions (where target is not IT-MGMT-TST or IT-MGMT-PRD):
#### Monitoring Provider
* azure_provider_monitoringstore = {
  tenant_id              = "53f3dc0a-512f-4399-817d-c4a55242d086"
  subscription_id        = "d952b48a-3183-48cf-8a23-8c6f7f5a302f" #IT-MGMT-PRD
  region_alias           = "eus2"
  region                 = "eastus2"
  environment_type_alias = "prd"
  suffix                 = "infra"
  landingzone_key        = "Management"
  landingzone_alias      = "mgmt"
}

NOTE:  For application centric monitoring, this can be substituted for a central app solution store location(subscription) in app solution deployments.  This allows solution owners to centralize and manage their own alerts for the solution, as subject matter expierts, and app monitoring will share the lifecycle of the solution.
#### Action Groups
* For Infrastructure monitoring - 
Action Groups use Resource ID rather than a key in MAG object, as they are pre-deployed in IT-MGMT-PRD
  * For health Alerts 
  action = {
        action_group = {
          id = "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f/resourceGroups/rg-monitoringinfra-prd-eus2/providers/Microsoft.Insights/actiongroups/mag-infra-healthalerts-prd-eus2"
        }
      }
  
  * For metric alerts
  action = {
        action_group = {
          id = "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f/resourceGroups/rg-monitoringinfra-prd-eus2/providers/Microsoft.Insights/actiongroups/mag-infra-metricalerts-prd-eus2"
        }
      }
#### Resource Health per Resource Type
* Per Resource Type for Resource health the following line changes
  * criteria = {
        resource_type  = "Microsoft.OperationalInsights/workspaces"
* All PRD/TST monitoring resources are stored in
  * Legacy > "rg-monitoringinfra-prd-eus2" resource group   > New state as of 08/27/2024 all regional alert rules will be stored in local subscription rg-inframon-eus2 and rg-inframon-cus respectively.
  
* All Dev monitors for validation are stored in
  * Legacy > "rg-monitoringinfra-tst-eus2" > New state as of 08/27/2024 all regional alert rules will be stored in local subscription rg-inframon-eus2 and rg-inframon-cus respectively.
  * Dev monitors are destroyed after validation and promoted to PRD/TST environments where applicable

#### Monitoring SCOPE (target) per Subscription/per Monitoring Alert Rule
* Example:
  scopes = [
        "/subscriptions/ba59ea46-####-####-####-############" # *Subscription-Display-Name*
  ]
## Deployment Notes
Goal is to remove "true" sandbox deployments from subscription resources.
Example "it-syssvc-test".  This sandbox is intended for manual deployment/testing and resources should be destroyed/deleted regularly (daily/weekly)
NOTE:  Removed it-syssvcs-test.tfvars from deployment

<!-- BEGIN_TF_DOCS -->
<!-- Automatically generated by terraform-docs. Do not manually adjust between the BEGIN_TF_DOCS and END_TF_DOCS lines. -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.1 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.53.1 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 3.116.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.53.1 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.116.0 |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_monitor_action_groups"></a> [monitor\_action\_groups](#module\_monitor\_action\_groups) | git::${MODULE_BASE}/terraform-azurerm-monitoring//modules/monitoring/monitor_action_group | v3.2.2 |
| <a name="module_monitor_activity_log_alert"></a> [monitor\_activity\_log\_alert](#module\_monitor\_activity\_log\_alert) | git::${MODULE_BASE}/terraform-azurerm-monitoring//modules/monitoring/monitor_activity_log_alert | v3.2.2 |
| <a name="module_monitor_metric_alert"></a> [monitor\_metric\_alert](#module\_monitor\_metric\_alert) | git::${MODULE_BASE}/terraform-azurerm-monitoring//modules/monitoring/monitor_metric_alert | v3.2.2 |
| <a name="module_network_security_group"></a> [network\_security\_group](#module\_network\_security\_group) | git::${MODULE_BASE}/terraform-azurerm-spoke//modules/nsg | v2.0.0 |
| <a name="module_spoke"></a> [spoke](#module\_spoke) | git::${MODULE_BASE}/terraform-azurerm-spoke//modules/spoke | v2.0.0 |
| <a name="module_user_defined_routing"></a> [user\_defined\_routing](#module\_user\_defined\_routing) | git::${MODULE_BASE}/terraform-azurerm-spoke//modules/udr | v2.0.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/resources/resource_group) | resource |
| [azurerm_security_center_contact.this](https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/resources/security_center_contact) | resource |
| [null_resource.network_watcher](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azuread_service_principal.logged_in_app](https://registry.terraform.io/providers/hashicorp/azuread/2.53.1/docs/data-sources/service_principal) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/data-sources/client_config) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/data-sources/subscription) | data source |
| [azurerm_subscription.monitoringstore](https://registry.terraform.io/providers/hashicorp/azurerm/3.116.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_provider_monitoringstore"></a> [azure\_provider\_monitoringstore](#input\_azure\_provider\_monitoringstore) | Contains default deployment provider information | <pre>object({<br>    subscription_id        = string<br>    tenant_id              = string<br>    region                 = string<br>    region_alias           = string<br>    environment_type_alias = string<br>    suffix                 = string<br>    landingzone_key        = string<br>  })</pre> | n/a | yes |
| <a name="input_client_config"></a> [client\_config](#input\_client\_config) | Azure Client connection configuration info retrieved from current session | `map` | `{}` | no |
| <a name="input_cloud"></a> [cloud](#input\_cloud) | Configuration object - Cloud resources defaults to Azure public, allows you to switch to other Azure endpoints. | `map` | <pre>{<br>  "acrLoginServerEndpoint": ".azurecr.io",<br>  "activeDirectory": "https://login.microsoftonline.com",<br>  "activeDirectoryDataLakeResourceId": "https://datalake.azure.net/",<br>  "activeDirectoryGraphResourceId": "https://graph.windows.net/",<br>  "activeDirectoryResourceId": "https://management.core.windows.net/",<br>  "appInsightsResourceId": "https://api.applicationinsights.io",<br>  "appInsightsTelemetryChannelResourceId": "https://dc.applicationinsights.azure.com/v2/track",<br>  "attestationEndpoint": ".attest.azure.net",<br>  "attestationResourceId": "https://attest.azure.net",<br>  "azmirrorStorageAccountResourceId": "null",<br>  "azureDatalakeAnalyticsCatalogAndJobEndpoint": "azuredatalakeanalytics.net",<br>  "azureDatalakeStoreFileSystemEndpoint": "azuredatalakestore.net",<br>  "batchResourceId": "https://batch.core.windows.net/",<br>  "gallery": "https://gallery.azure.com/",<br>  "keyvaultDns": ".vault.azure.net",<br>  "logAnalyticsResourceId": "https://api.loganalytics.io",<br>  "management": "https://management.core.windows.net/",<br>  "mariadbServerEndpoint": ".mariadb.database.azure.com",<br>  "mediaResourceId": "https://rest.media.azure.net",<br>  "mhsmDns": ".managedhsm.azure.net",<br>  "microsoftGraphResourceId": "https://graph.microsoft.com/",<br>  "mysqlServerEndpoint": ".mysql.database.azure.com",<br>  "ossrdbmsResourceId": "https://ossrdbms-aad.database.windows.net",<br>  "portal": "https://portal.azure.com",<br>  "postgresqlServerEndpoint": ".postgres.database.azure.com",<br>  "resourceManager": "https://management.azure.com/",<br>  "sqlManagement": "https://management.core.windows.net:8443/",<br>  "sqlServerHostname": ".database.windows.net",<br>  "storageEndpoint": "core.windows.net",<br>  "storageSyncEndpoint": "afs.azure.net",<br>  "synapseAnalyticsEndpoint": ".dev.azuresynapse.net",<br>  "synapseAnalyticsResourceId": "https://dev.azuresynapse.net",<br>  "vmImageAliasDoc": "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json"<br>}</pre> | no |
| <a name="input_current_landingzone_key"></a> [current\_landingzone\_key](#input\_current\_landingzone\_key) | Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment. | `string` | `"local"` | no |
| <a name="input_custom_role_definitions"></a> [custom\_role\_definitions](#input\_custom\_role\_definitions) | Configuration object - Custom role definitions | `map` | `{}` | no |
| <a name="input_default_network_security_groups"></a> [default\_network\_security\_groups](#input\_default\_network\_security\_groups) | Map of NSGs that will be created by default in the subscription | `map` | <pre>{<br>  "nsg-default-cus": {<br>    "location": "centralus",<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  },<br>  "nsg-default-eus2": {<br>    "location": "eastus2",<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_default_resource_groups"></a> [default\_resource\_groups](#input\_default\_resource\_groups) | Map of resource groups that will be created by default in the subscription | `map` | <pre>{<br>  "rg-inframon-cus": {<br>    "location": "centralus",<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  },<br>  "rg-inframon-eus2": {<br>    "location": "eastus2",<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  },<br>  "rg-network-cus": {<br>    "location": "centralus",<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  },<br>  "rg-network-eus2": {<br>    "location": "eastus2",<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_default_route_tables"></a> [default\_route\_tables](#input\_default\_route\_tables) | Map of UDRs that will be created by default in the subscription. This does not generally need to be changed, unless you want to use the Hub SB"<br>  Hub Sandbox<pre>"udr-tohub-eus2" = {<br>    location = "eastus2"<br><br>    routes = {<br>        "DefaultGateway" = {<br>          address_prefix         = "0.0.0.0/0"<br>          next_hop_type          = "VirtualAppliance"<br>          next_hop_in_ip_address = "172.28.180.62"<br>        }<br>      }<br>    }<br><br>  "udr-tohub-cus" = {<br>      location = "centralus"<br><br>      routes = {<br>        "DefaultGateway" = {<br>          address_prefix         = "0.0.0.0/0"<br>          next_hop_type          = "VirtualAppliance"<br>          next_hop_in_ip_address = "172.28.181.62"<br>        }<br>      }<br>    }</pre> | `map` | <pre>{<br>  "udr-tohub-cus": {<br>    "location": "centralus",<br>    "routes": {<br>      "DefaultGateway": {<br>        "address_prefix": "0.0.0.0/0",<br>        "next_hop_in_ip_address": "172.28.129.62",<br>        "next_hop_type": "VirtualAppliance"<br>      }<br>    },<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  },<br>  "udr-tohub-eus2": {<br>    "location": "eastus2",<br>    "routes": {<br>      "DefaultGateway": {<br>        "address_prefix": "0.0.0.0/0",<br>        "next_hop_in_ip_address": "172.28.128.62",<br>        "next_hop_type": "VirtualAppliance"<br>      }<br>    },<br>    "tags": {<br>      "EnvironmentType": "prd"<br>    }<br>  }<br>}</pre> | no |
| <a name="input_hub_subscription_id"></a> [hub\_subscription\_id](#input\_hub\_subscription\_id) | Default subscription id of the hub. Important to note this affects all peering and routing for the config - DO NOT CHANGE on non-sandbox subscriptions | `string` | `"b64b8a9d-f0a4-4e6a-8844-f0426e9b4fc2"` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Configuration object - identity resources | `map` | `{}` | no |
| <a name="input_logged_aad_app_objectId"></a> [logged\_aad\_app\_objectId](#input\_logged\_aad\_app\_objectId) | Used to set access policies based on the value 'logged\_in\_aad\_app' | `string` | `null` | no |
| <a name="input_logged_user_objectId"></a> [logged\_user\_objectId](#input\_logged\_user\_objectId) | Used to set access policies based on the value 'logged\_in\_user'. Can only be used in interactive execution with vscode. | `string` | `null` | no |
| <a name="input_managed_identities"></a> [managed\_identities](#input\_managed\_identities) | Configuration object - Azure managed identity resources | `map` | `{}` | no |
| <a name="input_monitored_subscriptions"></a> [monitored\_subscriptions](#input\_monitored\_subscriptions) | Configuration object - Subscriptions resources. | `map` | `{}` | no |
| <a name="input_monitoring"></a> [monitoring](#input\_monitoring) | Configuration object - Monitoring resources | `map` | `{}` | no |
| <a name="input_monitoring_solution_data"></a> [monitoring\_solution\_data](#input\_monitoring\_solution\_data) | Contains solution information | <pre>object({<br>    app_name        = string<br>    app_name_short  = string<br>    solution_owners = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_monitoring_tags"></a> [monitoring\_tags](#input\_monitoring\_tags) | Tags for specified monitoring resources | `map` | `{}` | no |
| <a name="input_network_security_groups"></a> [network\_security\_groups](#input\_network\_security\_groups) | Additional Network Security Groups to provision | `map` | `{}` | no |
| <a name="input_random_strings"></a> [random\_strings](#input\_random\_strings) | Configuration object - Random string generator resources | `map` | `{}` | no |
| <a name="input_remote_objects"></a> [remote\_objects](#input\_remote\_objects) | Remote objects map that will be used to combine input objects for reuse in child modules. | `map` | `{}` | no |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Map of additional resource groups to create. The key of each entry acts as the resource group name<br>  Example:<pre>"rg-sample-sb-eus2" = {<br>    location = "eastus2"<br>  },<br>  "rg-sample-prd-eus2" = {<br>    location = "eastus2"<br>  },<br>  "rg-sample-prd-cus" = {<br>    location = "centralus"<br>  }</pre> | `map` | `{}` | no |
| <a name="input_role_mapping"></a> [role\_mapping](#input\_role\_mapping) | Configuration object - Role mapping | `map` | <pre>{<br>  "built_in_role_mapping": {},<br>  "custom_role_mapping": {}<br>}</pre> | no |
| <a name="input_route_tables"></a> [route\_tables](#input\_route\_tables) | Additional Route Table/UDRs to provision | `map` | `{}` | no |
| <a name="input_storage"></a> [storage](#input\_storage) | Configuration object - Storage account resources | `map` | `{}` | no |
| <a name="input_storage_accounts"></a> [storage\_accounts](#input\_storage\_accounts) | Configuration object - Storage account resources | `map` | `{}` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | Subscription ID of the managed landing zone | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to add for all the resources deployed with this deployment | `map` | `{}` | no |
| <a name="input_target_log_analytics_workspace"></a> [target\_log\_analytics\_workspace](#input\_target\_log\_analytics\_workspace) | Information of the target log analytics workspace | <pre>object({<br>    region          = string<br>    name            = string<br>    rg              = string<br>    subscription_id = string<br>    customer_id     = string<br>  })</pre> | n/a | yes |
| <a name="input_tfstates"></a> [tfstates](#input\_tfstates) | Terraform states configuration object. Used in the context of landing zone deployment. | `map` | `{}` | no |
| <a name="input_use_msi"></a> [use\_msi](#input\_use\_msi) | Deployment using an MSI for authentication. | `bool` | `false` | no |
| <a name="input_var_folder_path"></a> [var\_folder\_path](#input\_var\_folder\_path) | n/a | `string` | `""` | no |
| <a name="input_vnets"></a> [vnets](#input\_vnets) | Map of vnets and subnets. The key of each entry acts as the vnet name<br>  Example:<pre>"vnet-heinztestingvnet-sb-eus2" = {<br>    location            = "eastus2"                     # [Required] Location of the VNET<br>    resource_group_name = "rg-heinztestingvnet-sb-eus2" # [Required] Resource Group of the VNET, by default this will be created. Set `create_virtual_network` to false if you wish to use existing RG<br>    address_space       = ["172.28.186.0/24"]           # [Required] Location of the VNET<br><br>    create_virtual_network = true                           # [Optional] Create the VNET. Defaults to `true`<br>    dns_servers            = ["172.28.32.4", "172.28.32.5"] # [Optional] List of DNS servers for the VNET. Defaults to `["172.28.32.4", "172.28.32.5"]`. Set to null if you don't want to user custom DNS servers.<br>    peer_to_hub            = true                           # [Optional] Peer to the respective region's hub. Defaults to rg-hub-prd-<region alias><br>    add_route_to_hubgw     = true                           # [Optional] Add the VNET's address space to the respective region's hubgw udr. Defaults to `true`, and will be added to udr-hubgw-<region alias><br>    add_route_to_hubtrust  = true                           # [Optional] Add the VNET's address space to the OTHER region(s) hubtrust udr. Defaults to `true`, and will be added to udr-hubtrust-<region alias><br><br>    subnets = {<br>      "subnet1" = {<br>        address_cidr = "172.28.186.0/27" # [Required] Address CIDR for the subnet<br><br>        nsg_name               = "nsg-default-eus2"    # [Optional] If not set, defaults to nsg-default-<region alias><br>        nsg_resouce_group_name = "rg-network-eus2" # [Optional] If not set, defaults to rg-network-<region alias><br><br>        udr_name               = "udr-tohub-eus2"      # [Optional] If not set, defaults to udr-tohub-<region alias><br>        udr_resouce_group_name = "rg-network-eus2" # [Optional] If not set, defaults to rg-network-<region alias><br>      }<br>      "subnet2" = {<br>        address_cidr = "172.28.186.32/27" # [Required] Address CIDR for the subnet<br>        attach_nsg   = false              # [Optional] No NSG will be attached to this subnet. If not set, defaults to true<br>        attach_udr   = false              # [Optional] No UDR will be attached to this subnet. If not set, defaults to true<br>      }<br>      "subnet3" = {<br>        address_cidr          = "172.28.186.32/27"    # [Required] Address CIDR for the subnet<br>        service_endpoints     = ["Microsoft.Storage"] # [Optional] List of service endpoints<br>        delegation = {                                # [Optional] Map of delegation<br>          app-service-plan = [<br>            {<br>              name    = "Microsoft.Web/serverFarms"<br>              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]<br>            }<br>          ]<br>        }<br>      }<br>    }<br>  }</pre> | `map` | `{}` | no |
<!-- END_TF_DOCS -->