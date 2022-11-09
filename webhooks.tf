
# A shared secret between GitHub and AWS that allows AWS
# CodePipeline to authenticate the request came from GitHub.
# Would probably be better to pull this from the environment
# or something like SSM Parameter Store.
locals {
  webhook_secret = "super-secret"
}

## Random string for WebHook Secret
resource random_string "webhook_secret" {
    count = (var.enable_webhook && var.generate_webhook_secret) ? 1 : 0

    length  = 32
    special = false
}

## Store WebHook Secret in SSM parameter store
resource aws_ssm_parameter "webhook_secret" {
    count = (var.enable_webhook && var.generate_webhook_secret) ? 1 : 0
    
    name        = format("/github/%s/webhook_secret", var.repository_name)
    description = "Webhook secret for Github Repo"
    type        = "SecureString"
    value       = random_string.webhook_secret[0].result

    tags = var.default_tags
}

resource aws_codepipeline_webhook "this" {
    count = var.enable_webhook ?  1 : 0

    name            = format("codepipeline-%s-webhook", var.repository_name)
    authentication  = coalesce(var.webhook_authentication, "UNAUTHENTICATED")
    target_action   = var.webhook_target_action
    target_pipeline = aws_codepipeline.this.name

    dynamic "authentication_configuration" {
        for_each = contains(["IP", "GITHUB_HMAC"], coalesce(var.webhook_authentication, "UNAUTHENTICATED")) ? [1] : []
        
        content {
            secret_token = local.webhook_secret
            allowed_ip_range = var.webhook_allowed_ip_range
        }        
    }

    dynamic "filter" {
        for_each = try(length(keys(var.webhook_filters)), 0) > 0 ? [var.webhook_filters] : []

        content {
            json_path    = filter.value.json_path
            match_equals = filter.value.match_eqauls
        }
    }
    
    tags = merge({"Name" = var.repository_name}, var.default_tags)
}


resource github_repository_webhook "this" {  
    count = var.enable_webhook ?  1 : 0

    name = format("github-%s-webhook", var.repository_name)

    repository = var.repository_name

    active = var.webhook_status
    events = var.webhook_events

    configuration {
        url          = aws_codepipeline_webhook.this.url
        content_type = var.webhook_payload_content_type
        insecure_ssl = var.webhook_insecure_ssl
        secret       = local.webhook_secret
    }
}