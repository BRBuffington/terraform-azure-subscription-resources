# Default LAW
target_log_analytics_workspace = {
  subscription_id = "d952b48a-3183-48cf-8a23-8c6f7f5a302f"
  rg              = "rg-mgmt-prd-eus02"
  name            = "law-default-eus02"
  region          = "eastus2"
  customer_id     = "3bc6a63c-bae8-4ead-b2df-194c561e366f"
}

monitoring_solution_data = {
  app_name        = "monitoringinfra"                                                               # Max 16 characters, but ensure the resources being deployed will allow more characters
  app_name_short  = "aminfra"                                                                       # Max 6 characters - Azure Monitoring Infrastructure (aminfra)
  solution_owners = ["cloudops@example.com", "ops@example.com"] # Emails
}