module "devops_bucket" {
    source = "git::https://github.com/arjstack/terraform-aws-s3?ref=v1.0.0"
    
    count = local.create_devops_bucket ? 1 : 0

    name = var.bucket_name
    
    enable_versioning   = lookup(var.bucket_configs, "enable_versioning", true)
    versioning          = lookup(var.bucket_configs, "enable_versioning", true) ? { status = "Enabled" } : {}

    enable_sse              = lookup(var.bucket_configs, "enable_sse", true)
    server_side_encryption  = lookup(var.bucket_configs, "enable_sse", true) ? { 
                                        sse_algorithm = lookup(var.bucket_configs, "sse_kms", true) ? "aws:kms" : "AES256"
                                        kms_key = lookup(var.bucket_configs, "use_kms_key", false) ? var.kms_key : null
                                    } : {}    
    acl = "private"

    default_tags = try(var.bucket_configs.tags, {})
}