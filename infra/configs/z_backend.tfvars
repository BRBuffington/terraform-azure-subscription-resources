/* Terraform State Backend Configurations
 * DO NOT ADJUST WITHOUT CONSULTING CLOUD ENGINEERING TEAM <cloudops@example.com>
 */

tenant_id            = "00000000-0000-0000-0000-000000000000"
subscription_id      = "00000000-0000-0000-0000-000000000000"
resource_group_name  = "RG-TERRAFORM-PRD"
storage_account_name = "saterraformprd"
container_name       = "workspaces"
key                  = "SS-Azure-SubscriptionResources/tfstate:"
