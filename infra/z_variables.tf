variable "subscription_id" {
  description = "Subscription ID of the managed landing zone"
  type        = string
}

variable "tags" {
  description = "Additional tags to add for all the resources deployed with this deployment"
  default     = {}
}

variable "hub_subscription_id" {
  description = "Default subscription id of the hub. Important to note this affects all peering and routing for the config - DO NOT CHANGE on non-sandbox subscriptions"
  type        = string
  default     = "b64b8a9d-f0a4-4e6a-8844-f0426e9b4fc2" # Connectivity
}

variable "default_network_security_groups" {
  description = "Map of NSGs that will be created by default in the subscription"
  default = {
    "nsg-default-eus2" = {
      location = "eastus2"
      tags     = { "EnvironmentType" = "prd" }
    }
    "nsg-default-cus" = {
      location = "centralus"
      tags     = { "EnvironmentType" = "prd" }
    }
  }
}

variable "default_route_tables" {
  description = <<-EOF
  Map of UDRs that will be created by default in the subscription. This does not generally need to be changed, unless you want to use the Hub SB"
    Hub Sandbox
    ```
    "udr-tohub-eus2" = {
      location = "eastus2"

      routes = {
          "DefaultGateway" = {
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "172.28.180.62"
          }
        }
      }

    "udr-tohub-cus" = {
        location = "centralus"

        routes = {
          "DefaultGateway" = {
            address_prefix         = "0.0.0.0/0"
            next_hop_type          = "VirtualAppliance"
            next_hop_in_ip_address = "172.28.181.62"
          }
        }
      }
    ```
  EOF
  default = {
    "udr-tohub-eus2" = {
      location = "eastus2"
      tags     = { "EnvironmentType" = "prd" }

      routes = {
        "DefaultGateway" = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "172.28.128.62"
        }
      }
    }
    "udr-tohub-cus" = {
      location = "centralus"
      tags     = { "EnvironmentType" = "prd" }

      routes = {
        "DefaultGateway" = {
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "172.28.129.62"
        }
      }
    }
  }
}

variable "default_resource_groups" {
  description = "Map of resource groups that will be created by default in the subscription"

  # We're creating a shared resource group to store the default nsg and route table (tohub)
  default = {
    "rg-network-eus2" = {
      location = "eastus2"
      tags     = { "EnvironmentType" = "prd" }
    }
    "rg-network-cus" = {
      location = "centralus"
      tags     = { "EnvironmentType" = "prd" }
    }
    "rg-inframon-eus2" = {
      location = "eastus2"
      tags     = { "EnvironmentType" = "prd" }
    }
    "rg-inframon-cus" = {
      location = "centralus"
      tags     = { "EnvironmentType" = "prd" }
    }
  }
}

variable "resource_groups" {
  description = <<-EOF
  Map of additional resource groups to create. The key of each entry acts as the resource group name
    Example:
    ```
    "rg-sample-sb-eus2" = {
      location = "eastus2"
    },
    "rg-sample-prd-eus2" = {
      location = "eastus2"
    },
    "rg-sample-prd-cus" = {
      location = "centralus"
    }
    ```
  EOF
  default     = {}
}

variable "vnets" {
  description = <<-EOF
  Map of vnets and subnets. The key of each entry acts as the vnet name
    Example:
    ```
    "vnet-heinztestingvnet-sb-eus2" = {
      location            = "eastus2"                     # [Required] Location of the VNET
      resource_group_name = "rg-heinztestingvnet-sb-eus2" # [Required] Resource Group of the VNET, by default this will be created. Set `create_virtual_network` to false if you wish to use existing RG
      address_space       = ["172.28.186.0/24"]           # [Required] Location of the VNET

      create_virtual_network = true                           # [Optional] Create the VNET. Defaults to `true`
      dns_servers            = ["172.28.32.4", "172.28.32.5"] # [Optional] List of DNS servers for the VNET. Defaults to `["172.28.32.4", "172.28.32.5"]`. Set to null if you don't want to user custom DNS servers.
      peer_to_hub            = true                           # [Optional] Peer to the respective region's hub. Defaults to rg-hub-prd-<region alias>
      add_route_to_hubgw     = true                           # [Optional] Add the VNET's address space to the respective region's hubgw udr. Defaults to `true`, and will be added to udr-hubgw-<region alias>
      add_route_to_hubtrust  = true                           # [Optional] Add the VNET's address space to the OTHER region(s) hubtrust udr. Defaults to `true`, and will be added to udr-hubtrust-<region alias>

      subnets = {
        "subnet1" = {
          address_cidr = "172.28.186.0/27" # [Required] Address CIDR for the subnet

          nsg_name               = "nsg-default-eus2"    # [Optional] If not set, defaults to nsg-default-<region alias>
          nsg_resouce_group_name = "rg-network-eus2" # [Optional] If not set, defaults to rg-network-<region alias>

          udr_name               = "udr-tohub-eus2"      # [Optional] If not set, defaults to udr-tohub-<region alias>
          udr_resouce_group_name = "rg-network-eus2" # [Optional] If not set, defaults to rg-network-<region alias>
        }
        "subnet2" = {
          address_cidr = "172.28.186.32/27" # [Required] Address CIDR for the subnet
          attach_nsg   = false              # [Optional] No NSG will be attached to this subnet. If not set, defaults to true
          attach_udr   = false              # [Optional] No UDR will be attached to this subnet. If not set, defaults to true
        }
        "subnet3" = {
          address_cidr          = "172.28.186.32/27"    # [Required] Address CIDR for the subnet
          service_endpoints     = ["Microsoft.Storage"] # [Optional] List of service endpoints
          delegation = {                                # [Optional] Map of delegation
            app-service-plan = [
              {
                name    = "Microsoft.Web/serverFarms"
                actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
              }
            ]
          }
        }
      }
    }
    ```
  EOF
  default     = {}
}

variable "network_security_groups" {
  description = "Additional Network Security Groups to provision"
  default     = {}
}

variable "route_tables" {
  description = "Additional Route Table/UDRs to provision"
  default     = {}
}
##-------------------------------------
#### Monitoring Additions
##-------------------------------------
variable "target_log_analytics_workspace" {
  description = "Information of the target log analytics workspace"
  type = object({
    region          = string
    name            = string
    rg              = string
    subscription_id = string
    customer_id     = string
  })
}

# Pipeline Settings
variable "azure_provider_monitoringstore" {
  description = "Contains default deployment provider information"
  type = object({
    subscription_id        = string
    tenant_id              = string
    region                 = string
    region_alias           = string
    environment_type_alias = string
    suffix                 = string
    landingzone_key        = string
  })
}
variable "monitoring_solution_data" {
  description = "Contains solution information"
  type = object({
    app_name        = string
    app_name_short  = string
    solution_owners = list(string)
  })
}

variable "monitoring_tags" {
  description = "Tags for specified monitoring resources"
  default     = {}
}

variable "client_config" {
  description = "Azure Client connection configuration info retrieved from current session"
  default     = {}
}
variable "remote_objects" {
  description = "Remote objects map that will be used to combine input objects for reuse in child modules."
  default     = {}
}

## Cloud variables
variable "cloud" {
  description = "Configuration object - Cloud resources defaults to Azure public, allows you to switch to other Azure endpoints."
  default = {
    acrLoginServerEndpoint                      = ".azurecr.io"
    attestationEndpoint                         = ".attest.azure.net"
    azureDatalakeAnalyticsCatalogAndJobEndpoint = "azuredatalakeanalytics.net"
    azureDatalakeStoreFileSystemEndpoint        = "azuredatalakestore.net"
    keyvaultDns                                 = ".vault.azure.net"
    mariadbServerEndpoint                       = ".mariadb.database.azure.com"
    mhsmDns                                     = ".managedhsm.azure.net"
    mysqlServerEndpoint                         = ".mysql.database.azure.com"
    postgresqlServerEndpoint                    = ".postgres.database.azure.com"
    sqlServerHostname                           = ".database.windows.net"
    storageEndpoint                             = "core.windows.net"
    storageSyncEndpoint                         = "afs.azure.net"
    synapseAnalyticsEndpoint                    = ".dev.azuresynapse.net"
    activeDirectory                             = "https://login.microsoftonline.com"
    activeDirectoryDataLakeResourceId           = "https://datalake.azure.net/"
    activeDirectoryGraphResourceId              = "https://graph.windows.net/"
    activeDirectoryResourceId                   = "https://management.core.windows.net/"
    appInsightsResourceId                       = "https://api.applicationinsights.io"
    appInsightsTelemetryChannelResourceId       = "https://dc.applicationinsights.azure.com/v2/track"
    attestationResourceId                       = "https://attest.azure.net"
    azmirrorStorageAccountResourceId            = "null"
    batchResourceId                             = "https://batch.core.windows.net/"
    gallery                                     = "https://gallery.azure.com/"
    logAnalyticsResourceId                      = "https://api.loganalytics.io"
    management                                  = "https://management.core.windows.net/"
    mediaResourceId                             = "https://rest.media.azure.net"
    microsoftGraphResourceId                    = "https://graph.microsoft.com/"
    ossrdbmsResourceId                          = "https://ossrdbms-aad.database.windows.net"
    portal                                      = "https://portal.azure.com"
    resourceManager                             = "https://management.azure.com/"
    sqlManagement                               = "https://management.core.windows.net:8443/"
    synapseAnalyticsResourceId                  = "https://dev.azuresynapse.net"
    vmImageAliasDoc                             = "https://raw.githubusercontent.com/Azure/azure-rest-api-specs/master/arm-compute/quickstart-templates/aliases.json"
  }
}
variable "current_landingzone_key" {
  description = "Key for the current landing zones where the deployment is executed. Used in the context of landing zone deployment."
  default     = "local"
  type        = string
}
variable "tfstates" {
  description = "Terraform states configuration object. Used in the context of landing zone deployment."
  default     = {}
}
variable "logged_user_objectId" {
  description = "Used to set access policies based on the value 'logged_in_user'. Can only be used in interactive execution with vscode."
  type        = string
  default     = null
}
variable "logged_aad_app_objectId" {
  description = "Used to set access policies based on the value 'logged_in_aad_app'"
  type        = string
  default     = null
}

variable "use_msi" {
  description = "Deployment using an MSI for authentication."
  default     = false
  type        = bool
}
variable "monitored_subscriptions" {
  description = "Configuration object - Subscriptions resources."
  default     = {}
}
variable "managed_identities" {
  description = "Configuration object - Azure managed identity resources"
  default     = {}
}

variable "custom_role_definitions" {
  description = "Configuration object - Custom role definitions"
  default     = {}
}
variable "role_mapping" {
  description = "Configuration object - Role mapping"
  default = {
    built_in_role_mapping = {}
    custom_role_mapping   = {}
  }
}

## Storage variables
variable "storage_accounts" {
  description = "Configuration object - Storage account resources"
  default     = {}
}
variable "storage" {
  description = "Configuration object - Storage account resources"
  default     = {}
}

# Shared services
variable "monitoring" {
  description = "Configuration object - Monitoring resources"
  default = {
    # monitor_action_group = {}
    # monitor_activity_log_alert = {}
    # monitor_metric_alert = {}
    # monitor_autoscale_settings = {}
  }
}

variable "var_folder_path" {
  default = ""
}

variable "random_strings" {
  description = "Configuration object - Random string generator resources"
  default     = {}
}

variable "identity" {
  description = "Configuration object - identity resources"
  default     = {}
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------