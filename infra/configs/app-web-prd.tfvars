subscription_id = "a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD

vnets = {
  # webcms for vm-based kentico
  # https://your-intranet/azure-reference-architecture

  "vnet-webcms-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.20.0/23"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.128.196"]

    subnets = {
      "PrivateLink" = {
        address_cidr                                   = "172.24.20.0/27"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }

      "Acgcom" = {
        address_cidr = "172.24.20.32/27"
      }

      "Gicom" = {
        address_cidr = "172.24.20.64/27"
      }

      "Gpcom" = {
        address_cidr = "172.24.20.96/27"
      }

      "Gpjp" = {
        address_cidr = "172.24.20.128/27"
      }

      "Gscom" = {
        address_cidr = "172.24.20.160/27"
      }

      "InvInfocom" = {
        address_cidr = "172.24.20.192/27"
      }

      "VM" = {
        address_cidr      = "172.24.20.224/27"
        service_endpoints = ["Microsoft.AzureActiveDirectory"]
        attach_nsg        = false #NSG attached with Web-Sites-CMSVM deployment
      }
    }
  }

  "vnet-webcms-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.20.0/23"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.129.196"]

    subnets = {
      "PrivateLink" = {
        address_cidr                                   = "172.25.20.0/27"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }

      "Acgcom" = {
        address_cidr = "172.25.20.32/27"
      }

      "Gicom" = {
        address_cidr = "172.25.20.64/27"
      }

      "Gpcom" = {
        address_cidr = "172.25.20.96/27"
      }

      "Gpjp" = {
        address_cidr = "172.25.20.128/27"
      }

      "Gscom" = {
        address_cidr = "172.25.20.160/27"
      }

      "InvInfocom" = {
        address_cidr = "172.25.20.192/27"
      }

      "VM" = {
        address_cidr      = "172.25.20.224/27"
        service_endpoints = ["Microsoft.AzureActiveDirectory"]
        attach_nsg        = false #NSG attached with Web-Sites-CMSVM deployment
      }
    }
  }
}

##-------------------------------------
#### Monitoring Additions
##-------------------------------------
azure_provider_monitoringstore = {
  tenant_id              = "53f3dc0a-512f-4399-817d-c4a55242d086"
  subscription_id        = "a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
  region_alias           = "eus2"
  region                 = "eastus2"
  environment_type_alias = "prd"
  suffix                 = "infra"
  landingzone_key        = "Management"
  landingzone_alias      = "mgmt"
}
monitoring = {
  monitor_activity_log_alert = {
    mala01 = {
      #mala_name           = "vm" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
        #Single Resource example below.
        #"/subscriptions/0ddd144b-76dd-4289-bd12-############/resourceGroups/rg-azmonprd-sb-eus2/providers/Microsoft.Compute/virtualMachines/vm-azmonprdw01-sb-eus2"
      ]
      description = "This alert will monitor resource health of all vms in target subscription."

      criteria = {
        resource_type  = "Microsoft.Compute/virtualMachines"
        operation_name = "Microsoft.Resourcehealth/healthevent/Activated/action"
        category       = "ResourceHealth"
        resource_health = {
          current = [
            "Degraded",
            "Unavailable",
            "Unknown"
          ]
          previous = [
            "Available" #Possible values "Available", "Degraded", "Unavailable", "Unknown"
          ]
          reason = [
            "PlatformInitiated",
            "UserInitiated",
            "Unknown"
          ]
        }
      }

      action = {
        action_group = {
          id = "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f/resourceGroups/rg-monitoringinfra-prd-eus2/providers/Microsoft.Insights/actiongroups/mag-infra-healthalerts-prd-eus2"
        }
      }
      tags = {
        "EnvironmentType" = "prd"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala02 = {
      #mala_name           = "db" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
        #Single Resource example below.
        #"/subscriptions/0ddd144b-76dd-4289-bd12-############/resourceGroups/rg-azmonprd-sb-eus2/providers/Microsoft.Sql/servers/databases/db01"
      ]
      description = "This alert will monitor resource health of all databases in target subscription."

      criteria = {
        resource_type  = "Microsoft.Sql/servers/databases"
        operation_name = "Microsoft.Resourcehealth/healthevent/Activated/action"
        category       = "ResourceHealth"
        resource_health = {
          current = [
            "Degraded",
            "Unavailable",
            "Unknown"
          ]
          previous = [
            "Available" #Possible values "Available", "Degraded", "Unavailable", "Unknown"
          ]
          reason = [
            "PlatformInitiated",
            "UserInitiated",
            "Unknown"
          ]
        }
      }

      #action = {}
      tags = {
        "EnvironmentType" = "prd"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala04 = {
      #mala_name           = "sa" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
      ]
      description = "This alert will monitor resource health of all storage accounts in target subscription."

      criteria = {
        resource_type  = "Microsoft.Storage/storageaccounts"
        operation_name = "Microsoft.Resourcehealth/healthevent/Activated/action"
        category       = "ResourceHealth"
        resource_health = {
          current = [ #Possible values "Available", "Degraded", "Unavailable", "Unknown"
            "Degraded",
            "Unavailable",
            "Unknown"
          ]
          previous = [
            "Available" #Possible values "Available", "Degraded", "Unavailable", "Unknown"
          ]
          reason = [ #Possible values "PlatformInitiated", "UserInitiated", "Unknown"
            "PlatformInitiated",
            "UserInitiated",
            "Unknown"
          ]
        }
      }

      action = {
        action_group = {
          id = "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f/resourceGroups/rg-monitoringinfra-prd-eus2/providers/Microsoft.Insights/actiongroups/mag-infra-healthalerts-prd-eus2"
        }
      }
      tags = {
        "EnvironmentType" = "prd"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
  }
  monitor_metric_alert = {
    mma01 = {
      #mma_name                 = "vm" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name      = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Compute/virtualmachines"
      target_resource_location = "East US 2"
      scopes = [
        "/subscriptions/a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
      ]
      description = "Action will be triggered when Percent CPU average is greater than 95 on VMs in target scope."

      criteria = {
        metric_namespace = "microsoft.compute/virtualmachines" #"Virtual machine standard metrics"
        metric_name      = "Percentage CPU"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 95

        dimension = {
          name     = "ApiName"
          operator = "Include"
          values   = ["*"]
        }
      }

      action = {
        action_group = {
          id = "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f/resourceGroups/rg-monitoringinfra-prd-eus2/providers/Microsoft.Insights/actiongroups/mag-infra-metricalerts-prd-eus2"
        }
      }
      tags = {
        "EnvironmentType" = "prd"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    },
    mma02 = {
      mma_name                 = "db"               #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name      = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Sql/servers/databases"
      target_resource_location = "East US 2"
      scopes = [
        "/subscriptions/a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
      ]
      description = "Data Space Used has exceeded 90 percent of max space.  Cleanup required or request additional space."

      criteria = {
        metric_namespace = "Microsoft.Sql/servers/databases" #"SQL DB standard metrics"
        metric_name      = "storage_percent"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90

        dimension = {
          name     = "ApiName"
          operator = "Include"
          values   = ["*"]
        }
      }

      #action = {}
      tags = {
        "EnvironmentType"       = "prd"
        "Lifecycle"             = "Runmode"
        "BusinessOwner"         = "Shared Services - IT"
        "Product"               = "Shared Infrastructure"
        "PrimaryITOwnerGroup"   = "cloudops@example.com"
        "ApplicationOwnerGroup" = "ops@example.com"
      }
    },
    mma03 = {
      mma_name                 = "db"              #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name      = "rg-inframon-cus" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Sql/servers/databases"
      target_resource_location = "Central US"
      scopes = [
        "/subscriptions/a84ca56e-9191-4e38-9bca-2ae61fc989b5" # IT-Web-Public-PRD
      ]
      description = "Data Space Used has exceeded 90 percent of max space.  Cleanup required or request additional space."

      criteria = {
        metric_namespace = "Microsoft.Sql/servers/databases" #"SQL DB standard metrics"
        metric_name      = "storage_percent"
        aggregation      = "Average"
        operator         = "GreaterThan"
        threshold        = 90

        dimension = {
          name     = "ApiName"
          operator = "Include"
          values   = ["*"]
        }
      }

      #action = {}
      tags = {
        "EnvironmentType"       = "prd"
        "Lifecycle"             = "Runmode"
        "BusinessOwner"         = "Shared Services - IT"
        "Product"               = "Shared Infrastructure"
        "PrimaryITOwnerGroup"   = "cloudops@example.com"
        "ApplicationOwnerGroup" = "ops@example.com"
      }
    }
  }
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------