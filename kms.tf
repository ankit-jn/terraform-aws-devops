## Provision KMS Key for 
## 1. encryption of CodeBuild Output artifacts and 
## 2. CodeBuild Bucket (if created as part of the provisioning)
## 2. CodePipeline Bucket (if created as part of the provisioning)
module "encryption" {
    source = "git::https://github.com/arjstack/terraform-aws-kms.git?ref=v1.0.0"

    count = local.create_kms_key ? 1 : 0

    account_id = var.account_id

    description = lookup(var.kms_key_configs, "description", null)

    key_spec = var.kms_key_configs.key_spec
    key_usage = var.kms_key_configs.key_usage

    aliases = try(var.kms_key_configs.aliases, [])

    bypass_policy_lockout_safety_check = lookup(var.kms_key_configs, "bypass_policy_lockout_safety_check", null)
    deletion_window_in_days = lookup(var.kms_key_configs, "deletion_window_in_days", null)
    enable_key_rotation = (var.kms_key_configs.key_spec == "SYMMETRIC_DEFAULT") ? lookup(var.kms_key_configs, "enable_key_rotation", null) : null
    multi_region = lookup(var.kms_key_configs, "multi_region", null)
    
    key_administrators = try(var.kms_key_configs.key_administrators, [])
    key_grants_users = try(var.kms_key_configs.key_grants_users, [])
    key_users = try(var.kms_key_configs.key_users, [])

    tags = try(var.kms_key_configs.tags, {})
}
