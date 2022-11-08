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

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="account_id"></a> [account_id](#input\_account\_id) | AWS account ID | `string` |  | yes |  |
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | Existing KMS: customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |  |
| <a name="policies"></a> [policies](#input\_policies) | List of Policies to be provisioned | `string` | `null` | no |  |

### CodeCommit Properties
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="repository_name"></a> [repository_name](#input\_repository\_name) | The name for the repository. | string | `null` | no |
| <a name="repository_description"></a> [repository_description](#input\_repository\_description) | The description for the repository. | `string` | `null` | no |

#### CodeBuild Properties

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="stages"></a> [stages](#codebuild\_stages) | List of CodeBuils Projects | `list` | `[]` | no |  |
| <a name="codebuild_policies"></a> [codebuild_policies](#input\_codebuild\_policies) | List of Policies to be attached with Service role for CodeBuild | `list` | <pre>[<br>   {<br>     "name"  = "AdministratorAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AdministratorAccess"<br>   },<br>   {<br>     "name"  = "AWSCodeCommitReadOnly"<br>     "arn"   = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"<br>   }<br>]<br> | no | <pre>[<br>   {<br>     "name" = "arjstack-custom-policy"<br>   },<br>   {<br>     "name"  = "AdministratorAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AdministratorAccess"<br>   }<br>]<br> |
| <a name="encrypt_artifacts"></a> [encrypt_artifacts](#input\_encrypt\_artifacts) | Flag to decide if the build project's build output artifacts should be encrypted | `bool` | `true` | no |  |

#### Buckets
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="codebuild_bucket_name"></a> [codebuild_bucket_name](#input\_codebuild\_bucket\_name) | Bucket name for Code Build | `string` |  | yes |
| <a name="codebuild_bucket_configs"></a> [codebuild_bucket_configs](#bucket\_configs) | Configuration for Codebuild bucket | `map(bool)` | <pre>{<br>   create = true<br>   enable_versioning = true<br>   enable_sse = true<br>   sse_kms = true<br>   use_kms_key = false<br>} | no |
| <a name="codepipeline_bucket_name"></a> [codepipeline_bucket_name](#input\codepipeline\_bucket\_name) | Bucket name for Code Pipeline | `string` |  | yes |
| <a name="codepipeline_bucket_configs"></a> [codepipeline_bucket_configs](#bucket\_configs) | Configuration for Codepipeline bucket | `map(bool)` | <pre>{<br>   create = true<br>   enable_versioning = true<br>   enable_sse = true<br>   sse_kms = true<br>   use_kms_key = false<br>} | no |

#### KMS Key

- `create_kms_key` will take preference over this property `kms_key` if it is set `true`
- Even if `create_kms_key` is set true , KMS key will be created only if any of the following conditions is met
    - `encrypt_artifacts` is set `true` (either implicit or explicit)]
    - All of the following properties are set `true`
      - `codebuild_bucket_configs.create`
      - `codebuild_bucket_configs.enable_sse`
      - `codebuild_bucket_configs.sse_kms`
      - `codebuild_bucket_configs.use_kms_key
    - All of the following properties are set `true`
      - `codepipeline_bucket_configs.create`
      - `codepipeline_bucket_configs.enable_sse`
      - `codepipeline_bucket_configs.sse_kms`
      - `codepipeline_bucket_configs.use_kms_key`

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="create_kms_key"></a> [create_kms_key](#input\_create\_kms\_key) | Flag to decide if KMS-Customer Master Key should be created to encrypt codebuild output artifacts | `bool` | `true` | no |  |
| <a name="kms_key_configs"></a> [kms_key_configs](#kms\_key\_configs) | AWS KMS: customer master key (CMK) Configurations. | `map(any)` | <pre>{<br>   key_spec    = "SYMMETRIC_DEFAULT"<br>   key_usage   = "ENCRYPT_DECRYPT"<br>} | no |  |

## Nested Configuration Maps:  

#### codebuild_stages

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------:|
| <a name="name"></a> [name](#input\_name) | Project's name. | `string` |  | yes |  |
| <a name="description"></a> [description](#input\_description) | Short description of the project. | `string` | `null` | no |  |
| <a name="env_image"></a> [env_image](#input\_env\_image) | Docker image to use for this build project. | `string` | `"aws/codebuild/standard:5.0"` | no |  |
| <a name="env_type"></a> [env_type](#input\_env\_type) | Type of build environment to use for related builds. | `string` | `"LINUX_CONTAINER"` | no |  |
| <a name="env_compute_type"></a> [env_compute_type](#input\_env\_compute_type) | Information about the compute resources the build project will use. | `string` | `"BUILD_GENERAL1_SMALL"` | no |  |
| <a name="env_certificate"></a> [env_certificate](#input\_env\_certificate) | ARN of the S3 bucket, path prefix and object key that contains the PEM-encoded certificate. | `string` | `null` | no |  |
| <a name="env_privileged_mode"></a> [env_privileged_mode](#input\_env\_privileged\_mode) | Whether to enable running the Docker daemon inside a Docker container.  | `bool` | `false` | no |  |
| <a name="env_credential_type"></a> [env_credential_type](#input\_env\_credential\_type) | Type of credentials AWS CodeBuild uses to pull images in your build. | `string` | `"CODEBUILD"` | no |  |
| <a name="env_variables"></a> [env_variables](#input\_env_variables) | List of Environment Variables Map | `list(map(string)` | `[]` | no | <pre>[<br>   {<br>     name = "param1"<br>     value = "testing"<br>     type = "PLAINTEXT"<br>   },<br>] |
| <a name="env_registry_credential"></a> [env_registry_credential](#input\_env\_registry\_credential) | ARN or name of credentials created using AWS Secrets Manager for accessing a private Docker registry. | `string` | `null` | no |  |
| <a name="build_timeout"></a> [build_timeout](#input\_build\_timeout) | Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | `number` | `60` | no |  |
| <a name="project_visibility"></a> [project_visibility](#input\_project\_visibility) | Specifies the visibility of the project's builds. | `string` | `"PRIVATE"` | no |  |
| <a name="queued_timeout"></a> [queued_timeout](#input\_queued\_timeout) | Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. | `number` | `480` | no |  |
| <a name="source_version"></a> [source_version](#input\_source\_version) | Version of the build input to be built for this project. If not specified, the latest version is used. | `string` | `null` | no |  |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to project. | `map(string)` | `{}` | no |  |

#### bucket_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="create"></a> [create](#input\_create) | Flag to decide if bucket should be created. | `bool` | `false` | no |
| <a name="enable_versioning"></a> [enable_versioning](#input\_enable\_versioning) | Flag to decide if bucket versioning is enabled. | `bool` | `true` | no |
| <a name="enable_sse"></a> [enable_sse](#input\_enable\_sse) | Flag to decide if server side encryption is enabled. | `bool` | `true` | no |
| <a name="sse_kms"></a> [sse_kms](#input\_sse\_kms) | Flag to decide if sse-algorithm is `aws-kms`. | `bool` | `true` | no |
| <a name="use_kms_key"></a> [use_kms_key](#input\_use\_kms\_key) | Flag to decide if KMS-CMK is used for encryption. | `bool` | `false` | no |

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
| <a name="kms_key"></a> [kms_key](#output\_kms\_key) | `map` | Attribute Map of KMS customer master key (CMK) to be used for encryption.<br>&nbsp;&nbsp;&nbsp;`key_id` - The Key ID KSM Key.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of KMS Key<br>&nbsp;&nbsp;&nbsp;`policy` - KMS Key Policy. |
| <a name="codebuild_bucket_arn"></a> [codebuild_bucket_arn](#output\_codebuild\_bucket\_arn) | `string` | Code Build Bucket ARN |
| <a name="codepipeline_bucket_arn"></a> [codepipeline_bucket_arn](#output\_codepipeline\_bucket\_arn) | `string` | Code pipeline Bucket ARN |


## Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-devops/graphs/contributors).

