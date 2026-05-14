locals {
  remote_objects = {
    monitor_action_groups = try(local.combined_objects_monitor_action_groups, null)
  }
}