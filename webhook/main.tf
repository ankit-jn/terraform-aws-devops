## Random string for WebHook Secret
resource random_string "webhook_secret" {
    count = var.generate_webhook_secret ? 1 : 0

    length  = 32
    special = false
}

## Store WebHook Secret in SSM parameter store
resource aws_ssm_parameter "webhook_secret" {
    count = var.generate_webhook_secret ? 1 : 0
    
    name        = coalesce(var.webhook_secret_param, format("/github/%s/webhook_secret", var.repository_name))
    description = "Webhook secret for Github Repo"
    type        = "SecureString"
    value       = random_string.webhook_secret[0].result

    tags = merge({"Name" = var.repository_name}, var.tags)
}

resource aws_codepipeline_webhook "this" {
    name            = format("codepipeline-%s-webhook", var.repository_name)
    authentication  = coalesce(var.authentication, "UNAUTHENTICATED")
    target_action   = var.target_action
    target_pipeline = var.target_pipeline

    dynamic "authentication_configuration" {
        for_each = contains(["IP", "GITHUB_HMAC"], coalesce(var.authentication, "UNAUTHENTICATED")) ? [1] : []
        
        content {
            secret_token = local.webhook_secret
            allowed_ip_range = var.allowed_ip_range
        }        
    }

    dynamic "filter" {
        for_each = try(length(keys(var.filters)), 0) > 0 ? [var.filters] : []

        content {
            json_path    = filter.value.json_path
            match_equals = filter.value.match_eqauls
        }
    }
    
    tags = merge({"Name" = var.repository_name}, var.tags)
}


resource github_repository_webhook "this" {

    name = format("github-%s-webhook", var.repository_name)

    repository = var.repository_name

    active = var.status
    events = var.events

    configuration {
        url          = aws_codepipeline_webhook.this.url
        content_type = var.payload_content_type
        insecure_ssl = var.insecure_ssl
        secret       = local.webhook_secret
    }
}