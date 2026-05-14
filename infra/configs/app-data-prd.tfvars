subscription_id = "ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD

vnets = {
  # ADF
  "vnet-mdmadf-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.12.0/24"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "Functions" = {
        address_cidr      = "172.24.12.0/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web"]

        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }

      "Functions-MDA" = {
        address_cidr      = "172.24.12.64/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web"]

        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }

      "Endpoints" = {
        address_cidr                                   = "172.24.12.128/25"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }

    }
  }

  "vnet-mdmadf-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.4.0/24"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "Functions" = {
        address_cidr      = "172.25.4.0/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web"]

        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Functions-MDA" = {
        address_cidr      = "172.25.4.64/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web"]

        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }

      "Endpoints" = {
        address_cidr                                   = "172.25.4.128/25"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }


    }
  }

  # PowerBI
  "vnet-mdmpbi-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.15.0/24"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "VirtualDataGateway" = {
        address_cidr      = "172.24.15.0/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        delegation = {
          data-gateway = [
            {
              name    = "Microsoft.PowerPlatform/vnetaccesslinks"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "PowerBI" = {
        address_cidr      = "172.24.15.64/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      }
      "Endpoints" = {
        address_cidr                                   = "172.24.15.128/25"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmpbi-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.6.0/24"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "VirtualDataGateway" = {
        address_cidr      = "172.25.6.0/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        delegation = {
          data-gateway = [
            {
              name    = "Microsoft.PowerPlatform/vnetaccesslinks"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "PowerBI" = {
        address_cidr      = "172.25.6.64/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      }
      "Endpoints" = {
        address_cidr                                   = "172.25.6.128/25"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmdata-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.0.0/24"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.128.196"]

    subnets = {
      "VirtualDataGateway" = {
        address_cidr      = "172.24.0.0/26"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
        delegation = {
          data-gateway = [
            {
              name    = "Microsoft.PowerPlatform/vnetaccesslinks"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "VM" = {
        address_cidr = "172.24.0.64/26"
      }
      "Endpoints" = {
        address_cidr                                   = "172.24.0.128/25"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }
}
##-------------------------------------
#### Monitoring Additions
##-------------------------------------
azure_provider_monitoringstore = {
  tenant_id              = "53f3dc0a-512f-4399-817d-c4a55242d086"
  subscription_id        = "ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
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
        "/subscriptions/ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
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
        "/subscriptions/ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
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
    mala03 = {
      mala_name           = "law"              #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
        #Example for single resource below
        #"/subscriptions/0ddd144b-76dd-4289-bd12-############/resourceGroups/rg-azmonprd-sb-eus2/providers/Microsoft.OperationalInsights/workspaces/law01"
      ]
      description = "This alert will monitor resource health of all log analytics workspaces in target subscription."

      criteria = {
        resource_type  = "Microsoft.OperationalInsights/workspaces"
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
    mala04 = {
      #mala_name           = "sa" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
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
        "/subscriptions/ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
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
        "/subscriptions/ba59ea46-bf0c-41de-9f19-568a1986568a" # GI-MDM-Data-PRD
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

      action = {
        action_group = {
          id = "/subscriptions/D952B48A-3183-48CF-8A23-8C6F7F5A302F/resourceGroups/RG-ACDBA-PRD/providers/microsoft.insights/actionGroups/AG-DBA-Support"
        }
      }
      tags = {
        "EnvironmentType"       = "prd"
        "Lifecycle"             = "Runmode"
        "BusinessOwner"         = "Acme Investments"
        "Product"               = "Master Data Management System"
        "PrimaryITOwnerGroup"   = "cloudops@example.com"
        "ApplicationOwnerGroup" = "ops@example.com"
      }
    }
  }
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------