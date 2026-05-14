subscription_id = "00000000-0000-0000-0000-000000000000"

vnets = {
  "vnet-aap-tst-cus" = {
    location            = "centralus"
    resource_group_name = "rg-network-cus"
    address_space       = ["172.24.16.64/26"]
    tags                = { "EnvironmentType" = "tst" }
    dns_servers         = ["172.28.129.196"]

    subnets = {
      "ansible" = {
        address_cidr      = "172.24.16.64/27"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web"]
      }

      "postgresql" = {
        address_cidr      = "172.24.16.96/27"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql", "Microsoft.Web"]

        delegation = {
          postgresql = [
            {
              name    = "Microsoft.DBforPostgreSQL/flexibleServers"
              actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
            }
          ]
        }
      }
    }
  }
}
##-------------------------------------
#### Monitoring Additions
##-------------------------------------
azure_provider_monitoringstore = {
  tenant_id              = "00000000-0000-0000-0000-000000000000"
  subscription_id        = "00000000-0000-0000-0000-000000000000"
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