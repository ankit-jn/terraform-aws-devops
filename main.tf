resource aws_codecommit_repository "this" {
    repository_name = var.repository_name
    description     = coalesce(var.repository_description, var.repository_name)

    tags = merge({"Name" = var.repository_name}, var.default_tags, var.repository_tags)
}

resource aws_codebuild_project "this" {

    for_each = { for stage in var.stages: stage.name => stage }
    
    name = format("%s-%s", var.repository_name, each.key)
    description = lookup(each.value, "description", format("Code build project for %s %s stage", var.repository_name, each.key))

    build_timeout = try(each.value.build_timeout, 60)
    encryption_key = var.encrypt_artifacts ? local.kms_key : null

    service_role = module.iam_devops.service_linked_roles[format("%s-codebuild", var.repository_name)].arn

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

    project_visibility = try(each.value.project_visibility, "PRIVATE")
    queued_timeout = try(each.value.queued_timeout, 480)
    source_version  = try(each.value.source_version, null)

    tags = merge({"Name" = format("%s-%s", var.repository_name, each.key)}, 
                        var.default_tags, var.project_tags, 
                        try(each.value.tags, {}))
}