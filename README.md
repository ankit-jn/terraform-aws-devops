# ARJ-Stack: AWS DevOps Terraform module

A Terraform module for configuring DevOps Infrastructure (Pipelines)

## Resources
This module features the following components to be provisioned with different combinations:

- KMS Key [[aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)]
- KMS Key Aliases [[aws_kms_alias](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias)]
- KMS Key Policy [[Key Policy](https://docs.aws.amazon.com/kms/latest/developerguide/key-policy-default.html)]


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

## Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-devops) for effectively utilizing this module.

## Inputs

- `create_encryption_key` will take preference over this property `encryption_key`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="account_id"></a> [account_id](#input\_account\_id) | AWS account ID | `string` |  | yes |  |
| <a name="enable_encryption"></a> [enable_encryption](#input\_enable\_encryption) | Flag to decide if the build project's build output artifacts should be encrypted | `bool` | `true` | no |  |
| <a name="encryption_key"></a> [encryption_key](#input\_encryption\_key) | Existing KMS: customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |  |
| <a name="create_encryption_key"></a> [create_encryption_key](#input\_create\_encryption\_key) | Flag to decide if KMS-Customer Master Key should be created to encrypt codebuild output artifacts | `bool` | `true` | no |  |
| <a name="encryption_key_configs"></a> [encryption_key_configs](#encryption\_key\_configs) | AWS KMS: customer master key (CMK) Configurations. | `map(any)` | <pre>{<br>   key_spec    = "SYMMETRIC_DEFAULT"<br>   key_usage   = "ENCRYPT_DECRYPT"<br>} | no |  |

## Nested Configuration Maps:  

#### encryption_key_configs

- Refer `https://github.com/arjstack/terraform-aws-kms/blob/main/README.md` for the detailed info of the structure.

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="description"></a> [description](#input\_description) | The description of the key as viewed in AWS console. | `string` | `null` | no |
| <a name="key_spec"></a> [key_spec](#input\_key\_spec) | Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports. | `string` | `"SYMMETRIC_DEFAULT"` | no |
| <a name="key_usage"></a> [key_usage](#input\_key\_usage) | Specifies the intended use of the key. | `string` | `"ENCRYPT_DECRYPT"` | no |
| <a name="aliases"></a> [aliases](#input\_aliases) | List of the aliases. | `list(string)` | `[]` | no |
| <a name="bypass_policy_lockout_safety_check"></a> [bypass_policy_lockout_safety_check](#input\_bypass\_policy\_lockout\_safety\_check) | Flag to decide if the key policy lockout safety check should be bypassed. | `bool` | `false` | no |
| <a name="deletion_window_in_days"></a> [deletion_window_in_days](#input\_deletion\_window\_in\_days) | The waiting period, specified in number of days. After the waiting period ends, AWS KMS deletes the KMS key. | `number` | `30` | no |
| <a name="enable_key_rotation"></a> [enable_key_rotation](#input\_enable\_key\_rotation) | Flag to decide if KMS key rotation is enabled | `bool` | `false` | no |
| <a name="multi_region"></a> [multi_region](#input\_multi\_region) | Flag to decide if KMS key is multi-region or regional. | `bool` | `false` | no |
| <a name="key_administrators"></a> [key_administrators](#input\_key\_administrators) | Flag to decide if KMS key is enabled. | `list(string)` | `[]` | no |
| <a name="key_grants_users"></a> [key_grants_users](#input\_key\_grants\_users) | Account ID where KMS key is being created | `list(string)` | `[]` | no |
| <a name="key_symmetric_encryption_users"></a> [key_symmetric_encryption_users](#input\_key\_symmetric\_encryption\_users) | List of ARNs for IAM principals that would be allowed to use the symmetric KMS key directly for all supported cryptographic operations | `list(string)` | `[]` | no |
| <a name="key_symmetric_hmac_users"></a> [key_symmetric_hmac_users](#input\_key\_symmetric\_hmac\_users) | List of ARNs for IAM principals that would be allowed to use the symmetric HMAC keys | `list(string)` | `[]` | no |
| <a name="key_asymmetric_public_encryption_users"></a> [key_asymmetric_public_encryption_users](#input\_key\_asymmetric\_public\_encryption\_users) | List of ARNs for IAM principals that would be allowed to use the asymmetric KMS key for Encrypt and decrypt. | `list(string)` | `[]` | no |
| <a name="key_asymmetric_sign_verify_users"></a> [key_asymmetric_sign_verify_users](#input\_key\_asymmetric\_sign\_verify\_users) | List of ARNs for IAM principals that would be allowed to use the asymmetric KMS key directly for Sign and Verify. | `list(string)` | `[]` | no |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to the KMS key. | `map` | `{}` | no |

## Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="encryption_key"></a> [encryption_key](#output\_encryption\_key) | `map` | Attribute Map of KMS customer master key (CMK) to be used for encrypting the build project's build output artifacts.<br>&nbsp;&nbsp;&nbsp;`key_id` - The Key ID KSM Key.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of KMS Key<br>&nbsp;&nbsp;&nbsp;`policy` - KMS Key Policy. |


## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-devops/graphs/contributors).

