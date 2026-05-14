# Default LAW
target_log_analytics_workspace = {
  subscription_id = "00000000-0000-0000-0000-000000000000"
  rg              = "rg-mgmt-prd-eus02"
  name            = "law-default-eus02"
  region          = "eastus2"
  customer_id     = "00000000-0000-0000-0000-000000000000"
}

monitoring_solution_data = {
  app_name        = "monitoringinfra"                                                               # Max 16 characters, but ensure the resources being deployed will allow more characters
  app_name_short  = "aminfra"                                                                       # Max 6 characters - Azure Monitoring Infrastructure (aminfra)
  solution_owners = ["cloudops@example.com", "ops@example.com"] # Emails
}