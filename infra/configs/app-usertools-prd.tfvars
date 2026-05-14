subscription_id = "e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD

vnets = {
  # PRD CUS
  "vnet-mdmutaks-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.0.0/24"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "AKS" = {
        address_cidr = "172.25.0.0/25"
        udr_name     = "udr-mdmutaks-prd-cus"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.EventHub"
        ]
      }
      "Endpoints" = {
        address_cidr                                   = "172.25.0.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  # PRD EUS2
  "vnet-mdmutaks-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.8.0/24"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "AKS" = {
        address_cidr = "172.24.8.0/25"
        udr_name     = "udr-mdmutaks-prd-eus2"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.EventHub"
        ]
      }
      "Endpoints" = {
        address_cidr                                   = "172.24.8.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }
  #10/02/2024 add service endpoints
  "vnet-mdmut-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.4.0/23"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.128.196"]

    subnets = {
      "Service1" = {
        address_cidr = "172.24.4.0/26",
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.Web"
        ]
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Service2" = {
        address_cidr = "172.24.4.64/26"
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Service3" = {
        address_cidr = "172.24.4.128/26"
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Service4" = {
        address_cidr = "172.24.4.192/26"
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Env1" = {
        address_cidr = "172.24.5.0/26"
        delegation = {
          "Microsoft.App.environments" = [
            {
              name    = "Microsoft.App/environments"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "Env2" = {
        address_cidr = "172.24.5.64/26"
        delegation = {
          "Microsoft.App.environments" = [
            {
              name    = "Microsoft.App/environments"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "Endpoints" = {
        address_cidr                                   = "172.24.5.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmut-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.12.0/23"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.129.196"]

    subnets = {
      "Service1" = {
        address_cidr = "172.25.12.0/26"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.Web"
        ]
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Service2" = {
        address_cidr = "172.25.12.64/26"
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Service3" = {
        address_cidr = "172.25.12.128/26"
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Service4" = {
        address_cidr = "172.25.12.192/26"
        delegation = {
          functions-webapp = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Env1" = {
        address_cidr = "172.25.13.0/26"
        delegation = {
          "Microsoft.App.environments" = [
            {
              name    = "Microsoft.App/environments"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "Env2" = {
        address_cidr = "172.25.13.64/26"
        delegation = {
          "Microsoft.App.environments" = [
            {
              name    = "Microsoft.App/environments"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
      "Endpoints" = {
        address_cidr                                   = "172.25.13.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }
}

route_tables = {
  # This route will be managed by the AKS cluster post provisioning
  "udr-mdmutaks-prd-eus2" = {
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
  # This route will be managed by the AKS cluster post provisioning
  "udr-mdmutaks-prd-cus" = {
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
##-------------------------------------
#### Monitoring Additions
##-------------------------------------
azure_provider_monitoringstore = {
  tenant_id              = "53f3dc0a-512f-4399-817d-c4a55242d086"
  subscription_id        = "e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
  region_alias           = "eus2"
  region                 = "eastus2"
  environment_type_alias = "prd"
  suffix                 = "infra"
  landingzone_key        = "Management"
  landingzone_alias      = "mgmt"
}

monitoring = {
  #NOTE - monitor_action_groups is not defined if exists in another subscription
  #monitor_action_group ID is used instead (see line 139 below as example)

  monitor_activity_log_alert = {
    mala01 = {
      #mala_name           = "vm" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
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
        "/subscriptions/e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
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
        "/subscriptions/e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
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
        "/subscriptions/e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
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
    mala05 = {
      mala_name           = "aks"              #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
        #Example for single resource below
        #"/subscriptions/0ddd144b-76dd-4289-bd12-############/resourceGroups/rg-azmonprd-sb-eus2/providers/Microsoft.OperationalInsights/workspaces/law01"
      ]
      description = "This alert will monitor resource health of all AKS Cluster services in target subscription."

      criteria = {
        resource_type  = "Microsoft.Containerservice/managedclusters"
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
  }
  monitor_metric_alert = {
    mma01 = {
      #mma_name                 = "vm-pctcpuavg" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name      = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Compute/virtualmachines"
      target_resource_location = "East US 2"
      scopes = [
        "/subscriptions/e3f29ff5-e556-4911-8eb4-33b5c41d62a0" # GI-MDM-UserTools-PRD
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
    }
  }
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------