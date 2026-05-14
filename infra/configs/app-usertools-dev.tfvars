subscription_id = "00000000-0000-0000-0000-000000000000" # GI-MDM-UserTools-DEV

vnets = {
  "vnet-mdmutaks-si-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.3.0/24"]
    tags                = { "EnvironmentType" = "si" }

    subnets = {
      "AKS" = {
        address_cidr = "172.25.3.0/25"
        udr_name     = "udr-mdmutaks-si-cus"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.EventHub"
        ]
      }
      "Endpoints" = {
        address_cidr                                   = "172.25.3.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmut-dev-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.25.10.0/23"]
    tags                = { "EnvironmentType" = "dev" }
    dns_servers         = ["172.28.129.196"]

    subnets = {
      "Service1" = {
        address_cidr      = "172.25.10.0/26"
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
        address_cidr = "172.25.10.64/26"
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
        address_cidr = "172.25.10.128/26"
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
        address_cidr = "172.25.10.192/26"
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
        address_cidr = "172.25.11.0/26"
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
        address_cidr = "172.25.11.64/26"
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
        address_cidr                                   = "172.25.11.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }

  "vnet-mdmutpoc-si-eus2" = {
    location            = "eastus2"
    resource_group_name = "rg-network-eus2"
    address_space       = ["172.24.10.0/24"]
    tags                = { "EnvironmentType" = "si" }
    dns_servers         = ["172.28.128.196"]

    subnets = {
      "Functions" = {
        address_cidr = "172.24.10.0/26"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.Web"
        ]
        delegation = {
          "Microsoft.Web.serverFarms" = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Logic" = {
        address_cidr = "172.24.10.64/26"
        service_endpoints = [
          "Microsoft.Storage",
          "Microsoft.Sql",
          "Microsoft.KeyVault",
          "Microsoft.Web"
        ]
        delegation = {
          "Microsoft.Web.serverFarms" = [
            {
              name    = "Microsoft.Web/serverFarms"
              actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
            }
          ]
        }
      }
      "Containers" = {
        address_cidr = "172.24.10.128/26"
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
        address_cidr                                   = "172.24.10.192/26"
        enforce_private_link_service_network_policies  = true
        enforce_private_link_endpoint_network_policies = true
      }
    }
  }
}

route_tables = {
  # This route will be managed by the AKS cluster post provisioning
  "udr-mdmutaks-si-cus" = {
    location = "centralus"
    tags     = { "EnvironmentType" = "si" }

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
  tenant_id              = "00000000-0000-0000-0000-000000000000"
  subscription_id        = "00000000-0000-0000-0000-000000000000" # GI-MDM-UserTools-DEV
  region_alias           = "eus2"
  region                 = "eastus2"
  environment_type_alias = "prd"
  suffix                 = "infra"
  landingzone_key        = "Management"
  landingzone_alias      = "mgmt"
}
##-------------------------------------
#### End Monitoring Additions
##-------------------------------------