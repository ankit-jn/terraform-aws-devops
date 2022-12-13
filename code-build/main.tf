resource aws_codebuild_project "this" {

    for_each = { for stage in var.build_stages: stage.name => stage }
    
    name = format("%s-%s-%s", var.repository_name, var.environment, each.key)
    description = lookup(each.value, "description", format("Code build project for %s %s stage", var.repository_name, each.key))

    encryption_key = var.encrypt_artifacts ? var.kms_key : null
    service_role = var.service_role

    artifacts {
        type = try(each.value.artifacts_type, "NO_ARTIFACTS")
        bucket_owner_access = try(each.value.artifacts_bucket_owner_access, null)
        location = try(each.value.artifacts_type, "NO_ARTIFACTS") == "S3" ? try(each.value.artifacts_location, null) : null
        name = try(each.value.artifacts_name, null)
        namespace_type = try(each.value.artifacts_namespace_type, null)
        override_artifact_name = try(each.value.artifacts_override_name, null)
        packaging = try(each.value.artifacts_packaging, null)
        path = try(each.value.artifacts_path, null)
    }

    environment {
        image = try(each.value.env_image, "aws/codebuild/standard:5.0")
        type = try(each.value.env_type, "LINUX_CONTAINER")
        compute_type = try(each.value.env_compute_type, "BUILD_GENERAL1_SMALL")
        certificate = try(each.value.env_certificate, null)
        privileged_mode = try(each.value.env_privileged_mode, false)
        image_pull_credentials_type = try(each.value.env_credential_type, "CODEBUILD")

        dynamic "environment_variable" {
            for_each = try(each.value.env_variables, [])

            content {
                name    = environment_variable.value.name
                type    = environment_variable.value.type
                value   = environment_variable.value.value
            }
        }

        dynamic "registry_credential" {
            for_each = try(each.value.env_registry_credential, "") != "" ? [1] : []

            content {
                credential = each.value.env_registry_credential
                credential_provider = "SECRETS_MANAGER"
            }
        }
    }

    source {
        type = try(each.value.source_type, "NO_SOURCE")
        buildspec = try(each.value.source_buildspec, "${path.root}/configs/buildspec.yaml")
        location = try(each.value.source_location, null)
        insecure_ssl = try(each.value.source_insecure_ssl, null)
        report_build_status = try(each.value.source_report_build_status, null)
    }

    dynamic "vpc_config" {
        for_each = try(each.value.vpc_id, "") != "" ? [1] : []
        content {
            vpc_id             = each.value.vpc_id
            subnets            = each.value.subnets
            security_group_ids = try(each.value.security_group_ids, [])
        }
    }

    cache {
        type = try(each.value.cache_type, "NO_CACHE")
        location = (try(each.value.cache_type, "NO_CACHE") == "S3") ? each.value.cache_location : null
        modes = (try(each.value.cache_type, "NO_CACHE") == "LOCAL") ? each.value.cache_modes : null
    }

    dynamic "logs_config" {
        for_each = (try(each.value.enable_cw_logs, false) 
                        || try(each.value.enable_s3_logs, false)) ? [1] : []

        content {
            dynamic "cloudwatch_logs" {
                for_each = try(each.value.enable_cw_logs, false) ? [1] : []

                content {
                    status      = "ENABLED"
                    group_name  = each.value.log_cw_name
                    stream_name = try(each.value.log_cw_stream, null)
                }
            }

            dynamic "s3_logs" {
                for_each = try(each.value.enable_s3_logs, false) ? [1] : []
                
                content {
                    status   = "ENABLED"
                    location = "${var.bucket_name}/${var.repository_name}/${each.key}/build_logs"
                }
                
            }
        }
    }

    build_timeout = try(each.value.build_timeout, 60)
    concurrent_build_limit = try(each.value.concurrent_build_limit, null)
    project_visibility = try(each.value.project_visibility, "PRIVATE")
    queued_timeout = try(each.value.queued_timeout, 480)
    source_version = try(each.value.source_version, null)
    badge_enabled = try(each.value.badge_enabled, null)
    
    tags = merge({"Name" = format("%s-%s-%s", var.repository_name, var.environment, each.key)}, 
                        var.tags, try(each.value.tags, {}))
}