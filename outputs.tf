output "codecommit_repository" {
    description = "CodeCommit Repository Attributes"
    value = var.create_repository ? {
                                    id  = aws_codecommit_repository.this[0].repository_id 
                                    arn = aws_codecommit_repository.this[0].arn
                                    clone_url_http = aws_codecommit_repository.this[0].clone_url_http
                                    clone_url_ssh = aws_codecommit_repository.this[0].clone_url_ssh
                                }: {}
}

output "codebuild_stages" {
    description = "CodeBuild Stages Attributes"
    value = {for stage in aws_codebuild_project.this: 
                        stage.name => {
                            id = stage.id
                            arn = stage.arn
                            badge_url = stage.badge_url
                        }}
}

output "codepipeline" {
    description = "CodePipeline Attributes"
    value = var.create_repository ? {
                                    id  = aws_codepipeline.this.id
                                    arn = aws_codepipeline.this.arn
                                }: {}
}

output "codebuild_bucket_arn" {
    description = "Code Build Bucket ARN"
    value = local.create_codebuild_bucket ? module.codebuild_bucket[0].arn : ""
}

output "codepipeline_bucket_arn" {
    description = "Code Pipeline Bucket ARN"
    value = local.create_codepipeline_bucket ? module.codepipeline_bucket[0].arn : ""
}

output "kms_key" {
    description = "KMS customer master key (CMK) to be used for encryption."
    value = local.create_kms_key ? {
                                    "key_id" = module.encryption[0].key_id
                                    "arn"    = module.encryption[0].key_arn 
                                    "policy" = module.encryption[0].key_policy 
                                } : null
}

output "ssm_parameter_webhook_secret" {
    description = "SSM parameter were webhook secret is stored."
    value = (var.enable_webhook 
                    && var.generate_webhook_secret) ? aws_ssm_parameter.webhook_secret[0].arn : ""
}