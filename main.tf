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

    source {
        type = "CODEPIPELINE"
    }

    environment {
        type = "LINUX_CONTAINER"
        image = "aws/codebuild/standard:5.0"
        compute_type = "BUILD_GENERAL1_SMALL"
    }

    artifacts {
        type = "CODEPIPELINE"
    }

    project_visibility = try(each.value.project_visibility, "PRIVATE")
    queued_timeout = try(each.value.queued_timeout, 480)
    source_version  = try(each.value.source_version, null)

    tags = merge({"Name" = format("%s-%s", var.repository_name, each.key)}, 
                        var.default_tags, var.project_tags, 
                        try(each.value.tags, {}))
}