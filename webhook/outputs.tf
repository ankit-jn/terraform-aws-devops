output "ssm_parameter_webhook_secret" {
    description = "SSM parameter were webhook secret is stored."
    value = var.generate_webhook_secret ? aws_ssm_parameter.webhook_secret[0].arn : ""
}