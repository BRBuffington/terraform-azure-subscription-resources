subscription_id = "0ddd144b-76dd-4289-bd12-5ac7dad5d168" # Formerly, IT-ENTERPRISE-SHAREDSERVICES-SB
resource_groups = {
  rg-monitoringinfra-tst-eus2 = {
    location = "eastus2"
    tags = {
      "EnvironmentType" = "tst"
      "Lifecycle"       = "Runmode"
      "BusinessOwner"   = "Shared Services - IT"
      "Product"         = "Shared Infrastructure"
    }
  }
  rg-monitoringinfra-tst-cus = {
    location = "centralus"
    tags = {
      "EnvironmentType" = "tst"
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
  subscription_id        = "0ddd144b-76dd-4289-bd12-5ac7dad5d168" #IT-MGMT-TST
  region_alias           = "eus2"
  region                 = "eastus2"
  environment_type_alias = "tst"
  suffix                 = "infra"
  landingzone_key        = "Management"
  landingzone_alias      = "mgmt"
}

monitoring = {
  monitor_action_groups = {
    mag1 = {
      create_mag             = true
      action_group_name      = "healthalerts"
      resource_group_name    = "rg-monitoringinfra-tst-eus2" #Pre-Req deployed with Subscription Resources composition
      action_group_shortname = "infrahealth"

      email_receiver = {
        email_alert1 = {
          name                    = "emailaction-alert-tst-infra"
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mag2 = {
      create_mag             = true
      action_group_name      = "metricalerts"
      resource_group_name    = "rg-monitoringinfra-tst-eus2" #Pre-Req deployed with SubscriptionResources composition - IT-MGMT-TST workspace
      action_group_shortname = "inframetric"

      email_receiver = {
        email_alert1 = {
          name                    = "emailaction-tst-alert-infra"
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
  }

  monitor_activity_log_alert = {
    mala01 = {
      #mala_name           = "vm" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168", #IT-MGMT-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala02 = {
      #mala_name           = "db" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168", #IT-MGMT-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala03 = {
      mala_name           = "law"              #custom-name append as dynamic name is "workspaces", result will be law-workspaces
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168", #IT-MGMT-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala04 = {
      #mala_name           = "svchealth-app-mgmt" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168", #IT-MGMT-TST
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
    mala05 = {
      #mala_name           = "sa" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      scopes = [
        "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168", #IT-MGMT-TST
        #Single Resource Example "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168/resourceGroups/rg-azmontst-sb-eus2/providers/Microsoft.OperationalInsights/workspaces/law-example"
      ]
      description = "This alert will monitor resource health of all log analytics workspaces in target subscription."

      criteria = {
        resource_type  = "Microsoft.Storage/storageaccounts"
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
        "EnvironmentType" = "tst"
        "Lifecycle"       = "Runmode"
        "BusinessOwner"   = "Shared Services - IT"
        "Product"         = "Shared Infrastructure"
      }
    }
  }

  monitor_metric_alert = {
    mma01 = {
      #mma_name                 = "vm" #(Optional)This is a custom name that can append the dynamic Alert Rule Name
      resource_group_name      = "rg-inframon-eus2" #Pre-Req deployed with Subscription Resources composition
      auto_mitigate            = true
      enabled                  = true
      frequency                = "PT5M"
      window_size              = "PT5M"
      severity                 = "1"
      target_resource_type     = "Microsoft.Compute/virtualmachines"
      target_resource_location = "East US 2"
      scopes = [
        "/subscriptions/0ddd144b-76dd-4289-bd12-5ac7dad5d168" #IT-MGMT-TST
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