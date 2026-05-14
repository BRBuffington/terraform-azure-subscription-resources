subscription_id = "d952b48a-3183-48cf-8a23-8c6f7f5a302f" # Formerly, IT-ENTERPRISE-SHAREDSERVICES, now IT-MGMT-PRD

vnets = {
  # ADDS Central US
  "vnet-aadds-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.28.33.128/25"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "DomainServices" = {
        address_cidr = "172.28.33.128/27"
        udr_name     = "udr-ads-domainservices-cus"
        attach_nsg   = false
      }

      "Mgmt" = {
        address_cidr = "172.28.33.160/27"
      }
    }
  }

  # ADDS East US 2
  "vnet-aadds-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.28.33.0/25"]
    tags                = { "EnvironmentType" = "prd" }

    subnets = {
      "DomainServices" = {
        address_cidr = "172.28.33.0/27"
        udr_name     = "udr-ads-domainservices-eus2"
        attach_nsg   = false
      }

      "Mgmt" = {
        address_cidr = "172.28.33.32/27"
      }
    }
  }

  "vnet-azinfra-prd-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.28.44.0/23"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.128.196"]

    subnets = {
      "AzDOAgents" = {
        address_cidr      = "172.28.44.0/26"
        service_endpoints = ["Microsoft.KeyVault"]
      }

      "Automation" = {
        address_cidr = "172.28.44.64/26"
      }

      "Monitoring" = {
        address_cidr = "172.28.44.128/26"
      }

      "Endpoints" = {
        address_cidr                                   = "172.28.45.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-azinfra-prd-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.28.46.0/23"]
    tags                = { "EnvironmentType" = "prd" }
    dns_servers         = ["172.28.129.196"]

    subnets = {
      "AzDOAgents" = {
        address_cidr      = "172.28.46.0/26"
        service_endpoints = ["Microsoft.KeyVault"]
      }

      "Automation" = {
        address_cidr = "172.28.46.64/26"
      }

      "Monitoring" = {
        address_cidr = "172.28.46.128/26"
      }

      "Endpoints" = {
        address_cidr                                   = "172.28.47.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }
}

route_tables = {
  "udr-ads-domainservices-cus" = {
    location = "centralus"
    tags     = { "EnvironmentType" = "prd" }

    routes = {
      "RFC1918-10" = {
        address_prefix         = "10.0.0.0/8"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.129.62"
      }

      "RFC1918-172-16" = {
        address_prefix         = "172.16.0.0/12"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.129.62"
      }

      "RFC1918-192-168" = {
        address_prefix         = "192.168.0.0/16"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.129.62"
      }
    }
  }

  "udr-ads-domainservices-eus2" = {
    location = "eastus2"
    tags     = { "EnvironmentType" = "prd" }

    routes = {
      "RFC1918-10" = {
        address_prefix         = "10.0.0.0/8"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.128.62"
      }

      "RFC1918-172-16" = {
        address_prefix         = "172.16.0.0/12"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.128.62"
      }

      "RFC1918-192-168" = {
        address_prefix         = "192.168.0.0/16"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "172.28.128.62"
      }
    }
  }
}

resource_groups = {
  rg-monitoringinfra-prd-eus2 = {
    location = "eastus2"
    tags = {
      "EnvironmentType" = "prd"
      "Lifecycle"       = "Runmode"
      "BusinessOwner"   = "Shared Services - IT"
      "Product"         = "Shared Infrastructure"
    }
  }
  rg-monitoringinfra-prd-cus = {
    location = "centralus"
    tags = {
      "EnvironmentType" = "prd"
      "Lifecycle"       = "Runmode"
      "BusinessOwner"   = "Shared Services - IT"
      "Product"         = "Shared Infrastructure"
    }
  }
}

##-------------------------------------
#### Monitoring Additions
##-------------------------------------
azure_provider_monitoringstore = {
  tenant_id              = "53f3dc0a-512f-4399-817d-c4a55242d086"
  subscription_id        = "d952b48a-3183-48cf-8a23-8c6f7f5a302f" #IT-MGMT-PRD
  region_alias           = "eus2"
  region                 = "eastus2"
  environment_type_alias = "prd"
  suffix                 = "infra"
  landingzone_key        = "Management"
  landingzone_alias      = "mgmt"
}

monitoring = {
  monitor_action_groups = {
    mag1 = {
      create_mag             = true
      action_group_name      = "healthalerts"
      resource_group_name    = "rg-monitoringinfra-prd-eus2" #Pre-Req deployed with Subscription Resources composition
      action_group_shortname = "infrahealth"

      email_receiver = {
        email_alert1 = {
          name                    = "emailaction-alert-prd-infra-eus2"
          email_address           = "ops@example.com"
          use_common_alert_schema = true
        }
      }
      arm_role_receiver = {
        role_alert1 = {
          name                    = "healthmonitor-alerts-owners"
          use_common_alert_schema = true
          role_name               = "Owner" #case-sensitive
        }
      }
      tags = {
        "EnvironmentType" = "prd"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mag2 = {
      create_mag             = true
      action_group_name      = "metricalerts"
      resource_group_name    = "rg-monitoringinfra-prd-eus2" #Pre-Req deployed with Subscription Resources composition
      action_group_shortname = "inframetric"

      email_receiver = {
        email_alert1 = {
          name                    = "emailaction-alert-prd-infra-eus2"
          email_address           = "ops@example.com"
          use_common_alert_schema = true
        }
      }

      arm_role_receiver = {
        role_alert1 = {
          name                    = "metricmonitor-alerts-owners"
          use_common_alert_schema = true
          role_name               = "Owner" #case-sensitive
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

  monitor_activity_log_alert = {
    mala01 = {
      #mala_name           = "vm" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-PRD workspace
      scopes = [
        "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f", #IT-MGMT-PRD
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
          key = "mag1"
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
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f", #IT-MGMT-PRD
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
          key = "mag1"
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
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f", #IT-MGMT-PRD
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
          key = "mag1"
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
      #mala_name           = "svchealth-app-mgmt" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f", #IT-MGMT-PRD
      ]
      description = "This alert will monitor service health of all resources in target subscriptions."

      criteria = {
        category = "ServiceHealth"
        service_health = {
          events = [
            "Incident",
            "Maintenance",
            "Informational",
            "ActionRequired",
            "Security"
          ]
          locations = [
            "East US 2",
            "East US",
            "Central US"
          ]
          #services = ["All"] #Defaults to All Services
        }
      }

      action = {
        action_group = {
          key = "mag1"
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
      resource_group_name      = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Compute/virtualmachines"
      target_resource_location = "East US 2"
      scopes = [
        "/subscriptions/d952b48a-3183-48cf-8a23-8c6f7f5a302f", #IT-MGMT-PRD
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
          key = "mag2"
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