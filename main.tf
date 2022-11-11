module "code_commit" {
    source = "./code-commit"

    count = var.create_repository ? 1 : 0

    repository_name         = var.repository_name
    repository_description  = var.repository_description

    tags = merge(var.default_tags, var.repository_tags)
}

module "code_build" {
    source = "./code-build"

    count = local.create_build_projects ? 1 : 0

    repository_name = var.repository_name
    service_role = module.iam_devops.service_linked_roles[local.codebuild_role_name].arn

    bucket_name = var.codebuild_bucket_name
    build_stages = var.build_stages

    encrypt_artifacts = var.encrypt_build_artifacts
    kms_key = local.kms_key

    tags = merge(var.default_tags, var.codebuild_tags)
}

module "code_pipeline" {

    source = "./code-pipeline"
    count = local.create_pipeline ? 1 : 0

    repository_name = var.repository_name
    pipeline_name = var.pipeline_name

    service_role = module.iam_devops.service_linked_roles[local.codepipeline_role_name].arn

    bucket_name = var.codepipeline_bucket_name
    bucket_region = local.create_codepipeline_bucket ? module.codepipeline_bucket[0].region : data.aws_s3_bucket.codepipeline[0].region
    artifact_stores = var.artifact_stores

    pipeline_stages = var.pipeline_stages
    
    encrypt_artifacts = var.encrypt_pipeline_artifacts
    kms_key = local.kms_key

    tags = merge(var.default_tags, var.codepipeline_tags)

    depends_on = [
        module.code_build
    ]
}

module "webhook" {
    source = "./webhook"

    count = var.enable_webhook ?  1 : 0

    repository_name = var.repository_name

    generate_webhook_secret = var.generate_webhook_secret
    webhook_secret_param = var.webhook_secret_param

    authentication = var.webhook_authentication
    target_action = var.webhook_target_action
    target_pipeline = var.pipeline_name
    allowed_ip_range = var.webhook_allowed_ip_range
    filters = var.webhook_filters
    status = var.webhook_status
    events = var.webhook_events
    payload_content_type = var.webhook_payload_content_type
    insecure_ssl = var.webhook_insecure_ssl

    tags = var.default_tags

    depends_on = [
        module.code_pipeline
    ]
}