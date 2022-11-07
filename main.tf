## Provision KMS Key for Code Build output artifact's encryption
module "encryption_key" {
    source = "git::https://github.com/arjstack/terraform-aws-kms.git?ref=v1.0.0"

    count = (var.enable_encryption && var.create_encryption_key) ? 1 : 0

    account_id = var.account_id

    description = lookup(var.encryption_key_configs, "description", null)

    key_spec = var.encryption_key_configs.key_spec
    key_usage = var.encryption_key_configs.key_usage

    aliases = try(var.encryption_key_configs.aliases, [])

    bypass_policy_lockout_safety_check = lookup(var.encryption_key_configs, "bypass_policy_lockout_safety_check", null)
    deletion_window_in_days = lookup(var.encryption_key_configs, "deletion_window_in_days", null)
    enable_key_rotation = (var.encryption_key_configs.key_spec == "SYMMETRIC_DEFAULT") ? lookup(var.encryption_key_configs, "enable_key_rotation", null) : null
    multi_region = lookup(var.encryption_key_configs, "multi_region", null)
    key_administrators = try(var.encryption_key_configs.key_administrators, [])
    key_grants_users = try(var.encryption_key_configs.key_grants_users, [])
    key_symmetric_encryption_users = try(var.encryption_key_configs.key_symmetric_encryption_users, [])
    key_symmetric_hmac_users = try(var.encryption_key_configs.key_symmetric_hmac_users, [])
    key_asymmetric_public_encryption_users = try(var.encryption_key_configs.key_asymmetric_public_encryption_users, [])
    key_asymmetric_sign_verify_users = try(var.encryption_key_configs.key_asymmetric_sign_verify_users, [])

    tags = try(var.encryption_key_configs.tags, {})
}