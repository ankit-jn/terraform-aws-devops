variable "repository_name" {
    description = "The name for the repository."
    type        = string
}

variable "generate_webhook_secret" {
    description = "Flag to decide if webhook secret is generated."
    type        = bool
}

variable "webhook_secret_param" {
    description = "SSM Parameter for Webhook secret."
    type        = string
}

variable "authentication" {
    description = "The type of authentication to use."
    type        = string
}

variable "target_action" {
    description = "The name of the action in a pipeline you want to connect to the webhook."
    type        = string
}

variable "target_pipeline" {
    description = "The name of the pipeline you want to connect to the webhook."
    type        = string
}

variable "allowed_ip_range" {
    description = "A valid CIDR block for IP filtering. if authentication type is `IP`."
    type        = string
}

variable "filters" {
    description = "List of WebHook Filters"
    type        = list(map(string))
}

variable "status" {
    description = "Flag to decide if the webhook should receive events."
    type        = bool
}

variable "events" {
    description = "List of webhook events."
    type        = list(string)
}

variable "payload_content_type" {
    description = "The content type for the payload."
    type        = string
}

variable "insecure_ssl" {
    description = "Insecure SSL boolean toggle."
    type        = bool
}

variable "tags" {
    description = "A map of tags to assign to all the resources."
    type        = map(string)
}