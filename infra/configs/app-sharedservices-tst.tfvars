subscription_id = "89d26d12-21e3-46a0-97ed-debf3ae13f7d" # IT-SharedServices-TST

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
  tenant_id              = "53f3dc0a-512f-4399-817d-c4a55242d086"
  subscription_id        = "89d26d12-21e3-46a0-97ed-debf3ae13f7d" # IT-SharedServices-TST
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