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

#### Buckets
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="codebuild_bucket_name"></a> [codebuild_bucket_name](#input\_codebuild\_bucket\_name) | Bucket name for Code Build | `string` |  | yes |  |
| <a name="codebuild_bucket_configs"></a> [codebuild_bucket_configs](#bucket\_configs) | Configuration for Codebuild bucket | `map(bool)` | <pre>{<br>   create = false<br>} | no |  |
| <a name="codepipeline_bucket_name"></a> [codepipeline_bucket_name](#input\codepipeline\_bucket\_name) | Bucket name for Code Pipeline | `string` |  | yes |  |
| <a name="codepipeline_bucket_configs"></a> [codepipeline_bucket_configs](#bucket\_configs) | Configuration for Codepipeline bucket | `map(bool)` | <pre>{<br>   create = false<br>} | no |  |

#### CodeBuild Output Artifact Encryption

- `create_kms_key` will take preference over this property `kms_key`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="account_id"></a> [account_id](#input\_account\_id) | AWS account ID | `string` |  | yes |  |
| <a name="encrypt_codebuild_artifacts"></a> [encrypt_codebuild_artifacts](#input\_encrypt\_codebuild\_artifacts) | Flag to decide if the build project's build output artifacts should be encrypted | `bool` | `true` | no |  |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | Existing KMS: customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |  |
| <a name="create_kms_key"></a> [create_kms_key](#input\_create\_kms\_key) | Flag to decide if KMS-Customer Master Key should be created to encrypt codebuild output artifacts | `bool` | `true` | no |  |
| <a name="kms_key_configs"></a> [kms_key_configs](#kms\_key\_configs) | AWS KMS: customer master key (CMK) Configurations. | `map(any)` | <pre>{<br>   key_spec    = "SYMMETRIC_DEFAULT"<br>   key_usage   = "ENCRYPT_DECRYPT"<br>} | no |  |

## Nested Configuration Maps:  

#### bucket_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="create"></a> [create](#input\_create) | Flag to decide if bucket should be created. | `bool` | `false` | no |
| <a name="enable_versioning"></a> [enable_versioning](#input\_enable\_versioning) | Flag to decide if bucket versioning is enabled. | `bool` | `true` | no |
| <a name="enable_sse"></a> [enable_sse](#input\_enable\_sse) | Flag to decide if server side encryption (SSE-kms) is enabled. | `bool` | `true` | no |

#### kms_key_configs

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
| <a name="kms_key"></a> [kms_key](#output\_kms\_key) | `map` | Attribute Map of KMS customer master key (CMK) to be used for encrypting the build project's build output artifacts.<br>&nbsp;&nbsp;&nbsp;`key_id` - The Key ID KSM Key.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of KMS Key<br>&nbsp;&nbsp;&nbsp;`policy` - KMS Key Policy. |
| <a name="codebuild_bucket_arn"></a> [codebuild_bucket_arn](#output\_codebuild\_bucket\_arn) | `string` | Code Build Bucket ARN |
| <a name="codepipeline_bucket_arn"></a> [codepipeline_bucket_arn](#output\_codepipeline\_bucket\_arn) | `string` | Code pipeline Bucket ARN |


## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-devops/graphs/contributors).

