subscription_id = "66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST

vnets = {
  # QA
  "vnet-mdmutaks-qa-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.2.0/24"]
    tags                = { "EnvironmentType" = "qa" }

    subnets = {
      "AKS" = {
        address_cidr = "172.25.2.0/25"
        udr_name     = "udr-mdmutaks-qa-cus"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.EventHub"
        ]
      }
      "Endpoints" = {
        address_cidr                                   = "172.25.2.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  # UAT
  "vnet-mdmutaks-uat-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.9.0/24"]
    tags                = { "EnvironmentType" = "uat" }

    subnets = {
      "AKS" = {
        address_cidr = "172.24.9.0/25"
        udr_name     = "udr-mdmutaks-uat-eus2"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.EventHub"
        ]
      }
      "Endpoints" = {
        address_cidr                                   = "172.24.9.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmut-tst-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.6.0/23"]
    tags                = { "EnvironmentType" = "tst" }
    dns_servers         = ["172.28.128.196"]

    subnets = {
      "Service1" = {
        address_cidr = "172.24.6.0/26"
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
        address_cidr = "172.24.6.64/26"
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
        address_cidr = "172.24.6.128/26"
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
        address_cidr = "172.24.6.192/26"
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
        address_cidr = "172.24.7.0/26"
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
        address_cidr = "172.24.7.64/26"
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
        address_cidr                                   = "172.24.7.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmut-tst-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.14.0/23"]
    tags                = { "EnvironmentType" = "tst" }
    dns_servers         = ["172.28.129.196"]

    subnets = {
      "Service1" = {
        address_cidr      = "172.25.14.0/26"
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
      "Service2" = {
        address_cidr = "172.25.14.64/26"
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
        address_cidr = "172.25.14.128/26"
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
        address_cidr = "172.25.14.192/26"
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
        address_cidr = "172.25.15.0/26"
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
        address_cidr = "172.25.15.64/26"
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
        address_cidr                                   = "172.25.15.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }
}

route_tables = {
  # This route will be managed by the AKS cluster post provisioning
  "udr-mdmutaks-uat-eus2" = {
    location = "eastus2"
    tags     = { "EnvironmentType" = "uat" }

    routes = {
      "DefaultGateway" = {
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.128.62"
      }
    }
  }
  # This route will be managed by the AKS cluster post provisioning
  "udr-mdmutaks-qa-cus" = {
    location = "centralus"
    tags     = { "EnvironmentType" = "qa" }

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
  subscription_id        = "66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST
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
        "/subscriptions/66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala02 = {
      #mala_name           = "db" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala03 = {
      mala_name           = "law"              #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala04 = {
      mala_name           = "aks"              #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
  }
  monitor_metric_alert = {
    mma01 = {
      #mma_name                 = "vm-pctcpuavg" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name      = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Compute/virtualmachines"
      target_resource_location = "East US 2"
      scopes = [
        "/subscriptions/66dc480c-273a-4ac9-9d54-13b595569c01" # GI-MDM-UserTools-TST
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
        "EnvironmentType" = "tst"
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