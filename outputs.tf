output "encryption_key" {
    description = "KMS customer master key (CMK) to be used for encrypting the build project's build output artifacts."
    value = (var.enable_encryption && var.create_encryption_key) ? {
                                           "key_id" = module.encryption_key[0].key_id
                                           "arn"    = module.encryption_key[0].key_arn 
                                           "policy" = module.encryption_key[0].key_policy 
                                        } : null
}
