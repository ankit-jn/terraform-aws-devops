locals {
    webhook_secret =var.generate_webhook_secret ? aws_ssm_parameter.webhook_secret[0].value : data.aws_ssm_parameter.webhook_secret[0].value
}