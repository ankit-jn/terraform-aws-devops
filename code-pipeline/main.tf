resource aws_codepipeline "this" {
    
    name = coalesce(var.pipeline_name, format("%s-pipeline", var.repository_name))

    role_arn = var.service_role

    artifact_store {
        location = var.bucket_name
        type     = "S3"
        region   = var.bucket_region
        dynamic "encryption_key" {
            for_each = var.encrypt_artifacts ? [1] : []

            content {
                id = var.kms_key
                type = "KMS"
            }
        }
    }

    ## Additional Artifact stores
    dynamic "artifact_store" {
        for_each = var.artifact_stores
        content {
            location = artifact_store.value.location
            type     = "S3"
            region   = lookup(artifact_store.value, "region", null)

            dynamic "encryption_key" {
                for_each = try(artifact_store.value.encryption_key, "") != "" ? [1] : []

                content {
                    id = artifact_store.value.encryption_key
                    type = "KMS"
                }
            }
        }
    }

    dynamic "stage" {
        for_each = var.pipeline_stages

        content {
            name = stage.value.name

            dynamic "action" {
                for_each = stage.value.actions

                content {
                    name        = action.value.name
                    category    = action.value.category
                    provider    = action.value.provider
                    version     = action.value.version
                    owner       = try(action.value.owner, "AWS")
                    
                    run_order   = try(action.value.run_order, null)
                    region      = try(action.value.region, null)
                    namespace   = try(action.value.namespace, null)
                    role_arn    = try(action.value.role_arn, null)

                    input_artifacts     = try(action.value.input_artifacts, null)
                    output_artifacts    = try(action.value.output_artifacts, null)

                    configuration = try(action.value.embed_configuration, false) ? {

                            ## Configuration for `CodeCommit` Provider
                            RepositoryName = (action.value.provider == "CodeCommit"
                                                || action.value.provider == "ECR") ? var.repository_name : null
                            BranchName = (action.value.provider == "CodeCommit"
                                            || action.value.provider == "CodeStarSourceConnection") ? action.value.configuration.BranchName : null
                            PollForSourceChanges = (action.value.provider == "CodeCommit"
                                                        || action.value.provider == "GitHub"
                                                        || (action.value.provider == "S3"
                                                                && action.value.category == "Source")) ? try(action.value.configuration.PollForSourceChanges, false) : null

                            ## Configuration for `CodeBuild` Provider
                            ProjectName = (action.value.provider == "CodeBuild") ? format("%s-%s", var.repository_name, action.value.configuration.ProjectName) : null
                            PrimarySource = (action.value.provider == "CodeBuild") ? try(action.value.configuration.PrimarySource, null) : null
                            BatchEnabled = (action.value.provider == "CodeBuild") ? try(action.value.configuration.BatchEnabled, false) : null
                            CombineArtifacts = (action.value.provider == "CodeBuild") ? try(action.value.configuration.CombineArtifacts, false) : null
                            EnvironmentVariables = (action.value.provider == "CodeBuild") ? jsonencode(try(action.value.configuration.EnvironmentVariables, [])) : null

                            ## Configuration for `CodeDeploy` Provider
                            ApplicationName = (action.value.provider == "CodeDeploy"
                                                || action.value.provider == "ECS") ? action.value.configuration.ApplicationName : null
                            DeploymentGroupName = (action.value.provider == "CodeDeploy"
                                                    || action.value.provider == "ECS") ? action.value.configuration.DeploymentGroupName : null

                            ## Configuration for `S3` Provider and `Source` Action
                            S3Bucket = (action.value.provider == "S3"
                                                && action.value.category == "Source") ? action.value.configuration.S3Bucket : null
                            S3ObjectKey = (action.value.provider == "S3"
                                                && action.value.category == "Source") ? action.value.configuration.S3ObjectKey : null
                            
                            ## Configuration for `S3` Provider and `Deploy` Action
                            BucketName = (action.value.provider == "S3"
                                            && action.value.category == "Deploy") ? action.value.configuration.BucketName : null
                            Extract = (action.value.provider == "S3"
                                            && action.value.category == "Deploy") ? action.value.configuration.Extract : null
                            ObjectKey = (action.value.provider == "S3"
                                            && action.value.category == "Deploy") ? try(action.value.configuration.ObjectKey, null) : null
                            KMSEncryptionKeyARN = (action.value.provider == "S3"
                                                        && action.value.category == "Deploy") ? try(action.value.configuration.KMSEncryptionKeyARN, null) : null
                            CannedACL = (action.value.provider == "S3"
                                            && action.value.category == "Deploy") ? try(action.value.configuration.CannedACL, null) : null
                            CacheControl = (action.value.provider == "S3"
                                                && action.value.category == "Deploy") ? try(action.value.configuration.CacheControl, null) : null

                            ## Configuration for `ECR` Provider
                            ImageTag = (action.value.provider == "ECR") ? try(action.value.configuration.ImageTag, null) : null

                            ## Configuration for `Lambda` Provider
                            FunctionName = (action.value.provider == "Lambda") ? action.value.configuration.FunctionName : null
                            UserParameters = (action.value.provider == "Lambda") ? try(action.value.configuration.UserParameters, null) : null

                            ## Configuration for `ECS` Provider
                            ClusterName = (action.value.provider == "ECS") ? action.value.configuration.ClusterName : null
                            ServiceName = (action.value.provider == "ECS") ? action.value.configuration.ServiceName : null
                            FileName = (action.value.provider == "ECS") ? try(action.value.configuration.FileName, null) : null
                            DeploymentTimeout = (action.value.provider == "ECS") ? try(action.value.configuration.DeploymentTimeout, null) : null
                            
                            ## Configuration for `CodeDeployToECS` Provider
                            TaskDefinitionTemplateArtifact = (action.value.provider == "ECS") ? try(action.value.configuration.TaskDefinitionTemplateArtifact, null) : null
                            AppSpecTemplateArtifact = (action.value.provider == "ECS") ? action.value.configuration.AppSpecTemplateArtifact : null
                            AppSpecTemplatePath = (action.value.provider == "ECS") ? try(action.value.configuration.AppSpecTemplatePath, null) : null
                            TaskDefinitionTemplatePath = (action.value.provider == "ECS") ? try(action.value.configuration.TaskDefinitionTemplatePath, null) : null
                            Image1ArtifactName = (action.value.provider == "ECS") ? try(action.value.configuration.Image1ArtifactName, null) : null
                            Image1ContainerName = (action.value.provider == "ECS") ? try(action.value.configuration.Image1ContainerName, null) : null

                            ## Configuration for `GitHub` [Version #1] Provider
                            Owner = (action.value.provider == "GitHub") ? action.value.configuration.Owner : null
                            Repo = (action.value.provider == "GitHub") ? action.value.configuration.Repo : null
                            Branch = (action.value.provider == "GitHub") ? action.value.configuration.Branch : null
                            OAuthToken = (action.value.provider == "GitHub") ? action.value.configuration.OAuthToken : null
                            

                            ## Configuration for `GitHub` [Version #2, BitBucket, GitHub Enterprise Server] Provider
                            ConnectionArn = (action.value.provider == "CodeStarSourceConnection") ? action.value.configuration.ConnectionArn : null
                            FullRepositoryId = (action.value.provider == "CodeStarSourceConnection") ? action.value.configuration.FullRepositoryId : null
                            OutputArtifactFormat = (action.value.provider == "CodeStarSourceConnection") ? try(action.value.configuration.OutputArtifactFormat, "CODE_ZIP") : null
                            DetectChanges = (action.value.provider == "CodeStarSourceConnection") ? try(action.value.configuration.DetectChanges, true) : null
                        } : null

                }
                
            }
        }
    }

    tags = merge({"Name" = coalesce(var.pipeline_name, format("%s-pipeline", var.repository_name))}, 
                    var.tags)

}