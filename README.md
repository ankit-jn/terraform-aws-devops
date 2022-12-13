## ARJ-Stack: AWS DevOps Terraform module

A Terraform module for configuring DevOps Infrastructure (CodeCommit Repository, CodeBuild, CodePipeline)

### Resources
This module features the following components to be provisioned with different combinations:

- IAM Policy [[aws_iam_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy)]
    - Policies to define permissions used by CodeBuild and CodePipeline Services
- IAM Roles [[aws_iam_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)]
    - (Service Linked) IAM Role that the CodeBuild Service can assume
    - (Service Linked) IAM Role that CodeDeploye Service can assume
- IAM Roles-Policy Attachments [[aws_iam_role_policy_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment)]
- S3 Bucket [[aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket)]
  - DevOps S3 Bucket (if common) that CodeBuild Project and CodePipeline may use.
- CodeCommit Repository [[aws_codecommit_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codecommit_repository)]
- CodeBuild Project [[aws_codebuild_project](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codebuild_project)]
- CodePipeline [[aws_codepipeline](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline)]
- CodePipeline Webhook [[aws_codepipeline_webhook](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codepipeline_webhook)]
- WebHook [[github_repository_webhook](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook)]
  - Webhooks for repositories within GitHub 

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.22.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.22.0 |

### Examples

Refer [Configuration Examples](https://github.com/arjstack/terraform-aws-examples/tree/main/aws-devops) for effectively utilizing this module.

### Inputs

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="repository_name"></a> [repository_name](#input\_repository\_name) | The name for the repository. | string |  | yes |
| <a name="default_tags"></a> [default_tags](#input\_default\_tags) | A map of tags to assign to all the resources. | `map(string)` | `{}` | no |  |

#### DevOps - IAM Properties

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="policies"></a> [policies](#input\_policies) | List of Policies to be provisioned | `list` | `[]` | no |  |
| <a name="create_codebuild_service_role"></a> [create_codebuild_service_role](#input\_create\_codebuild\_service\_role) | Flag to decide if Service role should be provisioned for CodeBuild | `bool` | `false` | no |  |
| <a name="codebuild_service_role_name"></a> [codebuild_service_role_name](#input\_codebuild\_service\_role\_name) | CodeBuild Service IAM Role Name | `string` | `null` | no |  |
| <a name="codebuild_policies"></a> [codebuild_policies](#input\_codebuild\_policies) | List of Policies to be attached with Service role for CodeBuild if `create_codebuild_service_role` is set `true` | `list` | <pre>[<br>   {<br>     "name"  = "AdministratorAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AdministratorAccess"<br>   },<br>   {<br>     "name"  = "AWSCodeCommitReadOnly"<br>     "arn"   = "arn:aws:iam::aws:policy/AWSCodeCommitReadOnly"<br>   }<br>]<br> | no | <pre>[<br>   {<br>     "name" = "arjstack-custom-policy"<br>   },<br>   {<br>     "name"  = "AdministratorAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AdministratorAccess"<br>   }<br>]<br> |
| <a name="create_codepipeline_service_role"></a> [create_codepipeline_service_role](#input\_create\_codepipeline\_service\_role) | Flag to decide if Service role should be provisioned for CodePipeline | `bool` | `false` | no |  |
| <a name="codepipeline_service_role_name"></a> [codepipeline_service_role_name](#input\_codepipeline\_service\_role\_name) | CodePipeline Service IAM Role Name | `string` | `null` | no |  |
| <a name="codepipeline_policies"></a> [codepipeline_policies](#input\_codepipeline\_policies) | List of Policies to be attached with Service role for CodePipeline if `create_codepipeline_service_role` is set `true`. | `list` | <pre>[<br>   {<br>     "name"  = "AdministratorAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AdministratorAccess"<br>   },<br>   {<br>     "name"  = "AWSCodeCommitFullAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AWSCodeCommitFullAccess"<br>   }<br>]<br> | no | <pre>[<br>   {<br>     "name" = "arjstack-custom-policy"<br>   },<br>   {<br>     "name"  = "AdministratorAccess"<br>     "arn"   = "arn:aws:iam::aws:policy/AdministratorAccess"<br>   }<br>]<br> |

#### DevOps Bucket Properties

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="create_bucket"></a> [create_bucket](#input\_create\_bucket) | Flag to decide if S3 bucket should be provisioned for DevOps. | `bool` | `false` | no |
| <a name="bucket_name"></a> [bucket_name](#input\_bucket\_name) | Bucket name to be used for DevOps artifacts | `string` | `null` | no |
| <a name="bucket_configs"></a> [bucket_configs](#bucket\_configs) | Configuration for DevOps bucket if,  to be created | `map(bool)` | <pre>{<br>   create = false<br>} | no |

#### CodeCommit Properties

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="create_repository"></a> [create_repository](#input\_create\_repository) | Flag to decide if repository is created in CodeCommit. | bool | `false` | no |
| <a name="repository_description"></a> [repository_description](#input\_repository\_description) | The description for the repository. | `string` | `null` | no |
| <a name="repository_tags"></a> [repository_tags](#input\_repository\_tags) | A map of tags to assign to the Repository. | `map(string)` | `{}` | no |  |

#### CodeBuild Properties

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="build_stages"></a> [build_stages](#codebuild\_stage) | List of CodeBuild Projects | `list` | `[]` | no |  |
| <a name="encrypt_codebuild_artifacts"></a> [encrypt_codebuild_artifacts](#input\_encrypt\_codebuild\_artifacts) | Flag to decide if the CodBuild project's build output artifacts should be encrypted | `bool` | `true` | no |  |
| <a name="codebuild_bucket"></a> [codebuild_bucket](#input\_codebuild\_bucket) | Bucket name for Code Build | `string` | `null` | no |
| <a name="codebuild_tags"></a> [codebuild_tags](#input\_codebuild\_tags) | A map of tags to assign to all the CodeBuild Projects. | `map(string)` | `{}` | no |  |

#### CodePipeline Properties

- Default `artifact_store` will be configured to S3 bucket defined with `codepipeline_bucket_name`. Use `artifact_stores` to define additional one (if required)

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="pipeline_name"></a> [pipeline_name](#input\_pipeline\_name) | The name of the pipeline. | `string` | `null` | no |  |
| <a name="cross_region"></a> [cross_region](#input\_cross\_region) | Flag to tell if Pipeline is cross region. | `bool` | `false` | no |  |
| <a name="pipeline_stages"></a> [pipeline_stages](#codepipeline\_stage) | List of CodePipeline stages | `list` | `[]` | no |  |
| <a name="encrypt_pipeline_artifacts"></a> [encrypt_codepipeline_artifacts](#input\_encrypt\_codepipeline\_artifacts) | Flag to decide if the CodePipeline output artifacts should be encrypted | `bool` | `true` | no |  |
| <a name="artifact_stores"></a> [artifact_stores](#artifact\_store) | List of Configuration for additional Artifact Store. | `list(map(string))` | `[]` | no |  |
| <a name="codepipeline_bucket"></a> [codepipeline_bucket](#input\codepipeline\_bucket) | Bucket name for CodePipeline | `string` | `null` | no |
| <a name="codepipeline_tags"></a> [codepipeline_tags](#input\_codepipeline\_tags) | A map of tags to assign to the CodePipeline. | `map(string)` | `{}` | no |  |

#### WebHook Properties

| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="enable_webhook"></a> [enable_webhook](#input\_enable\_webhook) | Flag to decide if webhook is enabled. | `bool` | `false` | no |  |
| <a name="generate_webhook_secret"></a> [generate_webhook_secret](#input\_generate\_webhook\_secret) | Flag to decide if webhook secret is generated. | `bool` | `true` | no |  |
| <a name="webhook_secret_param"></a> [webhook_secret_param](#input\_webhook\_secret\_param) | SSM Parameter for Webhook secret. | `string` | null | no |  |
| <a name="webhook_authentication"></a> [webhook_authentication](#input\_webhook\_authentication) | The type of authentication to use. | `string` | `"UNAUTHENTICATED"` | no |  |
| <a name="webhook_target_action"></a> [webhook_target_action](#input\_webhook\_target\_action) | The name of the action in a pipeline you want to connect to the webhook. The action must be from the source (first) stage of the pipeline. | `string` | `null` | no |  |
| <a name="webhook_allowed_ip_range"></a> [webhook_allowed_ip_range](#input\_webhook\_allowed\_ip\_range) | A valid CIDR block for IP filtering. if authentication type is `IP`. | `string` | `null` | no |  |
| <a name="webhook_filters"></a> [webhook_filters](#input\_webhook\_filters) | List of WebHook Filters. | `list(map(string))` | `[]` | no | <pre>[<br>  {<br>    json_path    = "$.ref"<br>    match_equals = "refs/heads/{Branch}"<br>  }<br>] |
| <a name="webhook_status"></a> [webhook_status](#input\_webhook\_status) | Flag to decide if the webhook should receive events. | `bool` | `true` | no |  |
| <a name="webhook_events"></a> [webhook_events](#input\_webhook\_events) | List of webhook events. | `list(string)` | `["push"]` | no |  |
| <a name="webhook_payload_content_type"></a> [webhook_payload_content_type](#input\_webhook\_payload\_content\_type) | The content type for the payload. | `string` | `"json"` | no |  |
| <a name="webhook_insecure_ssl"></a> [webhook_insecure_ssl](#input\_webhook\_insecure\_ssl) | Insecure SSL boolean toggle. | `bool` | `false` | no |  |

#### KMS Key Properties
| Name | Description | Type | Default | Required | Example|
|:------|:------|:------|:------|:------:|:------|
| <a name="kms_key"></a> [kms_key](#input\_kms\_key) | Existing KMS: customer master key (CMK) to be used for encrypting the build project's build output artifacts. | `string` | `null` | no |  |

### Nested Configuration Maps:  

#### codebuild_stage

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------:|
| <a name="name"></a> [name](#input\_name) | Project's name. | `string` |  | yes |  |
| <a name="description"></a> [description](#input\_description) | Short description of the project. | `string` | `null` | no |  |
| <a name="artifacts_type"></a> [artifacts_type](#input\_artifacts\_type) | Build output artifact's type.  | `string` | `"NO_ARTIFACTS"` | no |  |
| <a name="artifacts_bucket_owner_access"></a> [artifacts_bucket_owner_access](#input\_artifacts\_bucket\_owner\_access) | Specifies the bucket owner's access for objects that another account uploads to their Amazon S3 bucket. Valid values are `NONE`, `READ_ONLY`, and `FULL`. | `string` | `null` | no |  |
| <a name="artifacts_location"></a> [artifacts_location](#input\_artifacts\_location) | Information about the build output artifact location. If type is set to `CODEPIPELINE` or `NO_ARTIFACTS`, this value is ignored. If type is set to `S3`, this is the name of the output bucket. | `string` | `null` | no |  |
| <a name="artifacts_name"></a> [artifacts_name](#input\_artifacts\_name) | Name of the project. If type is set to S3, this is the name of the output artifact object. | `string` | `null` | no |  |
| <a name="artifacts_namespace_type"></a> [artifacts_namespace_type](#input\_artifacts\_namespace\_type) | Namespace to use in storing build artifacts. If type is set to S3, then valid values are `BUILD_ID`, `NONE`. | `string` | `null` | no |  |
| <a name="artifacts_override_name"></a> [artifacts_override_name](#input\_artifacts\_override\_name) | Whether a name specified in the build specification overrides the artifact name. | `string` | `null` | no |  |
| <a name="artifacts_packaging"></a> [artifacts_packaging](#input\_artifacts\_packaging) | Type of build output artifact to create. If type is set to S3, valid values are `NONE`, `ZIP` | `string` | `null` | no |  |
| <a name="artifacts_path"></a> [artifacts_path](#input\_artifacts\_path) | If type is set to S3, this is the path to the output artifact. | `string` | `null` | no |  |
| <a name="env_image"></a> [env_image](#input\_env\_image) | Docker image to use for this build project. | `string` | `"aws/codebuild/standard:5.0"` | no |  |
| <a name="env_type"></a> [env_type](#input\_env\_type) | Type of build environment to use for related builds. | `string` | `"LINUX_CONTAINER"` | no |  |
| <a name="env_compute_type"></a> [env_compute_type](#input\_env\_compute_type) | Information about the compute resources the build project will use. | `string` | `"BUILD_GENERAL1_SMALL"` | no |  |
| <a name="env_certificate"></a> [env_certificate](#input\_env\_certificate) | ARN of the S3 bucket, path prefix and object key that contains the PEM-encoded certificate. | `string` | `null` | no |  |
| <a name="env_privileged_mode"></a> [env_privileged_mode](#input\_env\_privileged\_mode) | Whether to enable running the Docker daemon inside a Docker container.  | `bool` | `false` | no |  |
| <a name="env_credential_type"></a> [env_credential_type](#input\_env\_credential\_type) | Type of credentials AWS CodeBuild uses to pull images in your build. | `string` | `"CODEBUILD"` | no |  |
| <a name="env_variables"></a> [env_variables](#input\_env_variables) | List of Environment Variables Map | `list(map(string)` | `[]` | no | <pre>[<br>   {<br>     name = "param1"<br>     value = "testing"<br>     type = "PLAINTEXT"<br>   },<br>] |
| <a name="env_registry_credential"></a> [env_registry_credential](#input\_env\_registry\_credential) | ARN or name of credentials created using AWS Secrets Manager for accessing a private Docker registry. | `string` | `null` | no |  |
| <a name="source_type"></a> [source_type](#input\_source\_type) | Type of repository that contains the source code to be built. | `string` | `"NO_SOURCE"` | no |  |
| <a name="source_buildspec"></a> [source_buildspec](#input\_source\_buildspec) | Build specification to use for this build project's related builds. | `string` | `"<ROOT-DIR>/configs/buildspec.yaml"` | no |  |
| <a name="source_location"></a> [source_location](#input\_source\_location) | Location of the source code from git or s3. | `string` | `null` | no |  |
| <a name="source_insecure_ssl"></a> [source_insecure_ssl](#input\_source\_insecure\_ssl) | Ignore SSL warnings when connecting to source control. | `string` | `null` | no |  |
| <a name="source_report_build_status"></a> [source_report_build_status](#input\_source\_report\_build\_status) | Whether to report the status of a build's start and finish to your source provider. | `string` | `null` | no |  |
| <a name="vpc_id"></a> [vpc_id](#input\_vpc\_id) | ID of the VPC within which to run builds. | `string` | `null` | no |  |
| <a name="subnets"></a> [subnets](#input\_subnets) | List of Subnet IDs within which to run builds. | `string` | `null` | no |  |
| <a name="security_group_ids"></a> [security_group_ids](#input\_security\_group\_ids) | List of Security group IDs to assign to running builds. | `string` | `null` | no |  |
| <a name="cache_type"></a> [cache_type](#input\_cache\_type) | Type of storage that will be used for the AWS CodeBuild project cache. | `string` | `"NO_CACHE"` | no |  |
| <a name="cache_location"></a> [cache_location](#input\_cache\_location) | Location where the AWS CodeBuild project stores cached resources. Required when `cache_type` is set as `S3`. | `string` | `null` | no |  |
| <a name="cache_modes"></a> [cache_modes](#input\_cache\_modes) | Specifies settings that AWS CodeBuild uses to store and reuse build dependencies. Required when `cache_type` is set as `LOCAL`. | `list(string)` | `null` | no |  |
| <a name="enable_cw_logs"></a> [enable_cw_logs](#input\_enable\_cw\_logs) | Flag to decide if Logging to Cloudwatch Group is enabled | `bool` | `false` | no |  |
| <a name="log_cw_name"></a> [log_cw_name](#input\_log\_cw\_name) | Group name of the logs in CloudWatch Logs. | `string` | `null` | no |  |
| <a name="log_cw_stream"></a> [log_cw_stream](#input\_log\_cw\_stream) | Stream name of the logs in CloudWatch Logs. | `string` | `null` | no |  |
| <a name="enable_s3_logs"></a> [enable_s3_logs](#input\_enable\_s3\_logs) | Flag to decide if Logging to S3 is enabled | `bool` | `false` | no |  |
| <a name="build_timeout"></a> [build_timeout](#input\_build\_timeout) | Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. | `number` | `60` | no |  |
| <a name="project_visibility"></a> [project_visibility](#input\_project\_visibility) | Specifies the visibility of the project's builds. | `string` | `"PRIVATE"` | no |  |
| <a name="concurrent_build_limit"></a> [concurrent_build_limit](#input\_concurrent\_build\_limit) | Specify a maximum number of concurrent builds for the project. | `number` | `null` | no |  |
| <a name="queued_timeout"></a> [queued_timeout](#input\_queued\_timeout) | Number of minutes, from 5 to 480 (8 hours), a build is allowed to be queued before it times out. | `number` | `480` | no |  |
| <a name="source_version"></a> [source_version](#input\_source\_version) | Version of the build input to be built for this project. If not specified, the latest version is used. | `string` | `null` | no |  |
| <a name="badge_enabled"></a> [badge_enabled](#input\_badge\_enabled) | Generates a publicly-accessible URL for the projects build badge. | `string` | `null` | no |  |
| <a name="tags"></a> [tags](#input\_tags) | A map of tags to assign to project. | `map(string)` | `{}` | no |  |

#### codepipeline_stage

| Name | Description | Type | Default | Required | Example |
|:------|:------|:------|:------|:------:|:------:|
| <a name="name"></a> [name](#input\_name) | The action declaration's name. | `string` |  | yes |
| <a name="category"></a> [category](#input\_category) | Kind of action can be taken in the stage, and constrains the provider type for the action.  | `string` |  | yes |
| <a name="provider"></a> [provider](#input\_provider) | The provider of the service being called by the action. | `string` |  | yes |
| <a name="version"></a> [version](#input\_version) | A string that identifies the action type. | `string` |  | yes |
| <a name="owner"></a> [owner](#input\_owner) | The creator of the action being called.  | `string` |  | yes |
| <a name="run_order"></a> [run_order](#input\_run\_order) | The order in which actions are run. | `number` |  | no |
| <a name="region"></a> [region](#input\_region) | The region in which to run the action. | `string` |  | no |
| <a name="namespace"></a> [namespace](#input\_namespace) | The namespace all output variables will be accessed from. | `string` |  | no |
| <a name="role_arn"></a> [role_arn](#input\_role_arn) | The ARN of the IAM service role that will perform the declared action. | `string` |  | no |
| <a name="input_artifacts"></a> [input_artifacts](#input\_input\_artifacts) | A list of artifact names to be worked on. | `list(string)` |  | no |
| <a name="output_artifacts"></a> [output_artifacts](#input\_output\_artifacts) | A list of artifact names to output.  | `list(string)` |  | no |
| <a name="enbed_configuration"></a> [enbed_configuration](#input\_embed_configuration) | Flag to decide if `configuration` should be embdded  | `bool` | `false` | no |
| <a name="configuration"></a> [configuration](#action\_configurations) | A map of the action declaration's configuration.  | `string` |  | no |

#### artifact_store

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="location"></a> [location](#input\_location) | The location where AWS CodePipeline stores artifacts for a pipeline. | `string` |  | yes |
| <a name="region"></a> [region](#input\_region) | The region where the artifact store is located. | `string` | `null` | no |
| <a name="encryption_key"></a> [encryption_key](#input\_encryption\_key) | The KMS key ARN or ID | `string` | `null` | no |

#### bucket_configs

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
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

#### action_configurations

- Each Provider needs a different configuration.
- Refer the [action requirements](https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html#action-requirements) to set the proper values

##### Provider: `CodeCommit`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="RepositoryName"></a> [RepositoryName](#input\_RepositoryName) | The name of the repository where source changes are to be detected. | `string` |  | yes |
| <a name="BranchName"></a> [BranchName](#input\_BranchName) | The name of the branch where source changes are to be detected. | `string` |  | yes |
| <a name="PollForSourceChanges"></a> [PollForSourceChanges](#input\_PollForSourceChanges) | Controls whether CodePipeline polls the CodeCommit repository for source changes | `bool` | `false` | no |

##### Provider: `CodeBuild`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="ProjectName"></a> [ProjectName](#input\_ProjectName) | The name of the build project in CodeBuild. | `string` |  | yes |
| <a name="PrimarySource"></a> [PrimarySource](#input\_PrimarySource) | The name of one of the input artifacts to the action. | `string` |  | yes |
| <a name="BatchEnabled"></a> [BatchEnabled](#input\_BatchEnabled) | Allows the action to run multiple builds in the same build execution. | `bool` | `false` | no |
| <a name="CombineArtifacts"></a> [CombineArtifacts](#input\_CombineArtifacts) |  Combines all build artifacts from a batch build into a single artifact file for the build action.| `bool` | `false` | no |
| <a name="EnvironmentVariables"></a> [EnvironmentVariables](#input\_EnvironmentVariables) | JSON array of environment variable objects (`name` and `value`). | `json code structure` | `[]` | no |

##### Provider: `CodeDeploy`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="ApplicationName"></a> [ApplicationName](#input\_ApplicationName) | The name of the application that you created in CodeDeploy. | `string` |  | yes |
| <a name="DeploymentGroupName"></a> [DeploymentGroupName](#input\_DeploymentGroupName) | The deployment group that you created in CodeDeploy. | `string` |  | yes |

##### Provider: `CloudFormation`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="StackName"></a> [StackName](#input\_StackName) |  | `string` |  | yes |
| <a name="ActionMode"></a> [ActionMode](#input\_ActionMode) |  | `string` |  | yes |
| <a name="Capabilities"></a> [Capabilities](#input\_Capabilities) |  | `string` |  | no |
| <a name="ChangeSetName"></a> [ChangeSetName](#input\_ChangeSetName) |  | `string` |  | no |
| <a name="RoleName"></a> [RoleName](#input\_RoleName) |  | `string` |  | yes |
| <a name="TemplatePath"></a> [TemplatePath](#input\_TemplatePath) |  | `string` |  | no |
| <a name="TemplateConfiguration"></a> [TemplateConfiguration](#input\_TemplateConfiguration) |  | `string` |  | no |
| <a name="OutputFileName"></a> [OutputFileName](#input\_OutputFileName) |  | `string` |  | no |

##### Provider: `S3`, Action: `Source`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="S3Bucket"></a> [S3Bucket](#input\_S3Bucket) | The name of the Amazon S3 bucket where source changes are to be detected. | `string` |  | yes |
| <a name="S3ObjectKey"></a> [S3ObjectKey](#input\_S3ObjectKey) | The name of the Amazon S3 object key where source changes are to be detected. | `string` |  | yes |
| <a name="PollForSourceChanges"></a> [PollForSourceChanges](#input\_PollForSourceChanges) | Controls whether CodePipeline polls the Amazon S3 source bucket for source changes.  | `bool` | `false` | no |

##### Provider: `S3`, Action: `Deploy`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="BucketName"></a> [BucketName](#input\_BucketName) | The name of the Amazon S3 bucket where files are to be deployed. | `string` |  | yes |
| <a name="Extract"></a> [Extract](#input\_Extract) | If true, specifies that files are to be extracted before upload. | `bool` |  | yes |
| <a name="ObjectKey"></a> [ObjectKey](#input\_ObjectKey) | The name of the Amazon S3 object key that uniquely identifies the object in the S3 bucket. | `string` | `null` | no |
| <a name="KMSEncryptionKeyARN"></a> [KMSEncryptionKeyARN](#input\_KMSEncryptionKeyARN) | The ARN of the AWS KMS encryption key for the host bucket. | `string` | `null` | no |
| <a name="CannedACL"></a> [CannedACL](#input\_CannedACL) | The CannedACL parameter applies the specified canned ACL to objects deployed to Amazon S3. | `string` | `null` | no |
| <a name="CacheControl"></a> [CacheControl](#input\_CacheControl) | Controls caching behavior for requests/responses for objects in the bucket | `string` | `null` | no |

##### Provider: `ECR`
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="RepositoryName"></a> [RepositoryName](#input\_RepositoryName) | The name of the Amazon ECR repository where the image was pushed. | `string` |  | yes |
| <a name="ImageTag"></a> [ImageTag](#input\_ImageTag) | The tag used for the image. | `string` | `null` | no |

##### Provider: AWS Lambda [`Lambda`]
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="FunctionName"></a> [FunctionName](#input\_FunctionName) | Name of the function created in Lambda. | `string` |  | yes |
| <a name="UserParameters"></a> [UserParameters](#input\_UserParameters) | A string that can be processed as input by the Lambda function. | `string` | `null` | no |

##### Provider: Amazon ECS [`ECS`]
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="ClusterName"></a> [ClusterName](#input\_ClusterName) | The Amazon ECS cluster in Amazon ECS. | `string` |  | yes |
| <a name="ServiceName"></a> [ServiceName](#input\_ServiceName) | The Amazon ECS service that you created in Amazon ECS. | `string` |  | yes |
| <a name="FileName"></a> [FileName](#input\_FileName) | The name of your image definitions file, the JSON file that describes your service's container name and the image and tag. | `string` | `null` | no |
| <a name="DeploymentTimeout"></a> [DeploymentTimeout](#input\_DeploymentTimeout) | The Amazon ECS deployment action timeout in minutes. | `string` | `null` | no |

##### Provider: Amazon ECS and CodeDeploy(Blue/Green) [`CodeDeployToECS`]
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="ApplicationName"></a> [ApplicationName](#input\_ApplicationName) | The name of the application in CodeDeploy. | `string` |  | yes |
| <a name="DeploymentGroupName"></a> [DeploymentGroupName](#input\_DeploymentGroupName) | The deployment group specified for Amazon ECS task sets that you created for your CodeDeploy application. | `string` |  | yes |
| <a name="TaskDefinitionTemplateArtifact"></a> [TaskDefinitionTemplateArtifact](#input\_TaskDefinitionTemplateArtifact) | The name of the input artifact that provides the task definition file to the deployment action. | `string` | `null` | no |
| <a name="AppSpecTemplateArtifact"></a> [AppSpecTemplateArtifact](#input\_AppSpecTemplateArtifact) | The name of the input artifact that provides the AppSpec file to the deployment action. | `string` |  | yes |
| <a name="AppSpecTemplatePath"></a> [AppSpecTemplatePath](#input\_AppSpecTemplatePath) | The file name of the AppSpec file stored in the pipeline source file location, such as your pipeline's CodeCommit repository. | `string` | `null` | no |
| <a name="TaskDefinitionTemplatePath"></a> [TaskDefinitionTemplatePath](#input\_TaskDefinitionTemplatePath) | The file name of the task definition stored in the pipeline file source location, such as your pipeline's CodeCommit repository. | `string` | `null` | no |
| <a name="Image1ArtifactName"></a> [Image1ArtifactName](#input\_Image1ArtifactName) | The name of the input artifact that provides the image to the deployment action. | `string` | `null` | no |
| <a name="Image1ContainerName"></a> [Image1ContainerName](#input\_Image1ContainerName) | The name of the image available from the image repository, such as the Amazon ECR source repository. | `string` | `null` | no |

##### Provider: `GitHub` [Version #1]
| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="Owner"></a> [Owner](#input\_Owner) | The name of the GitHub user or organization who owns the GitHub repository. | `string` |  | yes |
| <a name="Repo"></a> [Repo](#input\_Repo) | The name of the repository where source changes are to be detected. | `string` |  | yes |
| <a name="Branch"></a> [Branch](#input\_Branch) | The name of the branch where source changes are to be detected. | `string` |  | yes |
| <a name="OAuthToken"></a> [OAuthToken](#input\_OAuthToken) | GitHub authentication token that allows CodePipeline to perform operations on your GitHub repository. | `string` |  | yes |
| <a name="PollForSourceChanges"></a> [PollForSourceChanges](#input\_PollForSourceChanges) | Controls whether CodePipeline polls the GitHub repository for source changes | `bool` | `false` | no |

##### Provider: `CodeStarSourceConnection` [GitHub Version #2, BitBucket, GitHub Enterprise Server]

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="ConnectionArn"></a> [ConnectionArn](#input\_ConnectionArn) | The connection ARN that is configured and authenticated for the source provider. | `string` |  | yes |
| <a name="FullRepositoryId"></a> [FullRepositoryId](#input\_FullRepositoryId) | The owner and name of the repository where source changes are to be detected. | `string` |  | yes |
| <a name="BranchName"></a> [BranchName](#input\_BranchName) | The name of the branch where source changes are to be detected. | `string` |  | yes |
| <a name="OutputArtifactFormat"></a> [OutputArtifactFormat](#input\_OutputArtifactFormat) | Specifies the output artifact format. | `string` | `"CODE_ZIP"` | no |
| <a name="DetectChanges"></a> [DetectChanges](#input\_DetectChanges) | Controls automatically starting your pipeline when a new commit is made on the configured repository and branch. | `bool` | `true` | no |

##### Provider: `Manual` [Manual Approval]

| Name | Description | Type | Default | Required |
|:------|:------|:------|:------|:------:|
| <a name="NotificationTopic"></a> [NotificationTopic](#input\_NotificationTopic) | Name of the SNS topic on which approval notifiation will be sent | `string` |  | yes |
| <a name="ConnectionArn"></a> [CustomData](#input\_CustomData) | Custom Message | `string` |  | yes |

### Outputs

| Name | Type | Description |
|:------|:------|:------|
| <a name="bucket_arn"></a> [bucket_arn](#output\_bucket\_arn) | `string` | DevOps Bucket ARN |
| <a name="codebuild_service_role"></a> [codebuild_service_role](#output\_codebuild\_service\_role) | `string` | ARN of IAM Role for CodeBuild Service |
| <a name="codepipeline_service_role"></a> [codepipeline_service_role](#output\_codepipeline\_service\_role) | `string` | ARN of IAM Role for CodePipeline Service |
| <a name="codecommit_repository"></a> [codecommit_repository](#output\_codecommit\_repository) | `map(string)` | CodeCommit Repository Attributes.<br>&nbsp;&nbsp;&nbsp;`id` - The ID of the repository.<br>&nbsp;&nbsp;&nbsp;`arn` - The ARN of the repository.<br>&nbsp;&nbsp;&nbsp;`clone_url_http` - The URL to use for cloning the repository over HTTPS.<br>&nbsp;&nbsp;&nbsp;`clone_url_ssh` - The URL to use for cloning the repository over SSH.x |
| <a name="codebuild_projects"></a> [codebuild_projects](#output\_codebuild\_projects) | `map(map(string))` | CodeBuild Projects Map; with each entry having inner Stage Attributes Map<br>&nbsp;&nbsp;&nbsp;`id` - Name/ARN of the CodeBuild project.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of the CodeBuild project.<br>&nbsp;&nbsp;&nbsp;`badge_url` - URL of the build badge when badge_enabled is enabled. |
| <a name="codepipeline"></a> [codepipeline](#output\_codepipeline) | `map(string)` | CodePipeline Attributes<br>&nbsp;&nbsp;&nbsp;`id` - The codepipeline ID.<br>&nbsp;&nbsp;&nbsp;`arn` - The codepipeline ARN. |
| <a name="ssm_parameter_webhook_secret"></a> [ssm_parameter_webhook_secret](#output\_ssm\_parameter\_webhook\_secret) | `map(string)` | SSM parameter where webhook secret is stored. |
| <a name="kms_key"></a> [kms_key](#output\_kms\_key) | `map(string)` | Attribute Map of KMS customer master key (CMK) to be used for encryption.<br>&nbsp;&nbsp;&nbsp;`key_id` - The Key ID KSM Key.<br>&nbsp;&nbsp;&nbsp;`arn` - ARN of KMS Key<br>&nbsp;&nbsp;&nbsp;`policy` - KMS Key Policy. |

### Authors

Module is maintained by [Ankit Jain](https://github.com/ankit-jn) with help from [these professional](https://github.com/arjstack/terraform-aws-devops/graphs/contributors).

