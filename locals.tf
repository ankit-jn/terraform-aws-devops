locals {
    create_codebuild_bucket     = try(var.codebuild_bucket_configs.create, false)
    create_codepipeline_bucket  = try(var.codepipeline_bucket_configs.create, false)

    create_kms_key = var.create_kms_key && (var.encrypt_build_artifacts 
                                                || var.encrypt_pipeline_artifacts
                                                || (local.create_codebuild_bucket 
                                                            && try(var.codebuild_bucket_configs.enable_sse, true) 
                                                            && try(var.codebuild_bucket_configs.sse_kms, true) 
                                                            && try(var.codebuild_bucket_configs.use_kms_key, false))
                                                || (local.create_codepipeline_bucket
                                                            && try(var.codepipeline_bucket_configs.enable_sse, true) 
                                                            && try(var.codepipeline_bucket_configs.sse_kms, true) 
                                                            && try(var.codepipeline_bucket_configs.use_kms_key, false)))
    kms_key = local.create_kms_key ? module.encryption[0].key_id : try(var.kms_key, null)

    codebuild_role_name = format("codebuild-%s", var.repository_name)
    codepipeline_role_name = format("codepipeline-%s", var.repository_name)
    devops_roles = [                
                        {
                            name = local.codebuild_role_name
                            description = "IAM Role with trusted Entity - AWS CodeBuild Service"
                            service_names = [
                                "codebuild.amazonaws.com"
                            ]
                            policy_list =  var.build_policies            
                        },
                        {
                            name = local.codepipeline_role_name
                            description = "IAM Role with trusted Entity - AWS CodeBuild Service"
                            service_names = [
                                "codepipeline.amazonaws.com"
                            ]
                            policy_list =  var.pipeline_policies            
                        }
                    ]
    webhook_secret = var.enable_webhook ? (var.generate_webhook_secret ? aws_ssm_parameter.webhook_secret[0].value : data.aws_ssm_parameter.webhook_secret[0].value) : null
}