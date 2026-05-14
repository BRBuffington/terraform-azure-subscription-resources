locals {
  combined_objects_monitor_action_groups = merge(tomap({ (local.client_config.landingzone_key) = module.monitor_action_groups }), try(var.remote_objects.monitor_action_groups, {}))
}