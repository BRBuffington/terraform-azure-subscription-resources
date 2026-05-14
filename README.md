# terraform-azure-subscription-resources

Generic, multi-tenant-friendly Terraform stack for Azure **subscription-scope** resources: networking spokes, monitoring action groups + alerts, log analytics, policy assignments, and shared services. Driven entirely by tfvars files in [`infra/configs/`](infra/configs/).

Originally forked from `BRBuffington/SS-Azure-SubscriptionResources` and generalized: customer-specific names, internal app codes, and email addresses have been replaced with generic equivalents.

## Quick start

### 1. Set your module source base

The stack consumes modules from external repos (private or public). Terraform's HCL parser does **not** allow variables in `source =` arguments, so we use a literal placeholder `${MODULE_BASE}` that you search-and-replace before `terraform init`.

```powershell
# Replace with your org/host. Examples:
#   GitHub: https://github.com/your-org
#   ADO:    https://dev.azure.com/your-org/your-project/_git
$MODULE_BASE = "https://github.com/your-org"
Get-ChildItem infra -Recurse -File -Include *.tf | ForEach-Object {
    (Get-Content $_.FullName -Raw) -replace '\$\{MODULE_BASE\}', $MODULE_BASE |
        Set-Content $_.FullName -NoNewline
}
```

```bash
# Bash equivalent
MODULE_BASE="https://github.com/your-org"
grep -rl --include='*.tf' '${MODULE_BASE}' infra | \
  xargs sed -i "s|\${MODULE_BASE}|${MODULE_BASE}|g"
```

The stack depends on these module repos (you provide / fork them):

- `terraform-azurerm-spoke` — NSG, UDR, spoke VNet modules (`//modules/{nsg,udr,spoke}`)
- `terraform-azurerm-monitoring` — action groups, activity log alerts, metric alerts (`//modules/monitoring/{monitor_action_group,monitor_activity_log_alert,monitor_metric_alert}`)

### 2. Fill in tfvars

Start from [`infra/configs/cloud-production.tfvars.example`](infra/configs/cloud-production.tfvars.example) and the `app-*-{dev,tst,prd}.tfvars` files. Each `app-<name>-<env>.tfvars` represents one deployable workload-and-env combination.

Notification emails are configurable inline in each tfvars file — replace `securityops@example.com` and `cloudops@example.com` with your real distros.

### 3. Backend

See [`infra/configs/z_backend.tfvars`](infra/configs/z_backend.tfvars) for the remote state config (Azure Storage). Update to your storage account / container.

### 4. Pipeline

[`.azuredevops/terraform-cicd.yaml`](.azuredevops/terraform-cicd.yaml) is the Azure DevOps pipeline definition. For a GitHub Actions equivalent, see the companion `terraform-pipelines-github` repo.

## Layout

```
infra/
  main.tf            # root module wiring
  networking.tf      # spoke + NSG + UDR composition
  z_variables.tf     # input variables
  configs/
    cloud-production.tfvars.example   # shared subscription-level defaults
    z_common.tfvars / z_backend.tfvars / z_tags.yaml
    connectivity*.tfvars              # hub-to-spoke peering
    app-<name>-{dev,tst,prd}.tfvars   # per-workload, per-env
.azuredevops/
  terraform-cicd.yaml
```

## License

Inherited from upstream. Add your own LICENSE file before publishing externally.
