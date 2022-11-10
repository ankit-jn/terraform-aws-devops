# DevOps Roles for CodeBuild and COdePipeline
module "iam_devops" {
    source = "git::https://github.com/arjstack/terraform-aws-iam.git?ref=v1.0.0"
    
    policies = var.policies
    service_linked_roles = local.devops_roles
}