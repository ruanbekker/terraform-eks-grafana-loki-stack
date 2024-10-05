# terraform-eks-grafana-loki-stack
Grafana Stack, with Grafana, Prometheus, Loki, Promtail on AWS EKS

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks"></a> [eks](#module\_eks) | terraform-aws-modules/eks/aws | ~> v19.21.0 |
| <a name="module_loki_oidc_role"></a> [loki\_oidc\_role](#module\_loki\_oidc\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks | ~> 5.0 |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | ~> 5.0 |

## Resources

| Name | Type |
|------|------|
| [aws_elasticache_cluster.memcached](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_cluster) | resource |
| [aws_elasticache_subnet_group.memcached_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_iam_policy.grafana-loki-s3-policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role_policy_attachment.loki-attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_s3_bucket.grafana-loki-chunks-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.grafana-loki-ruler-bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_security_group.memcached_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [helm_release.grafana-loki-deployment](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.grafana-promtail](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.prometheus](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_default_tags"></a> [default\_tags](#input\_default\_tags) | Default tags to be applied to resources. | `map(string)` | `{}` | no |
| <a name="input_eks_capacity_type"></a> [eks\_capacity\_type](#input\_eks\_capacity\_type) | Capacity type (ON\_DEMAND, SPOT). | `string` | `"ON_DEMAND"` | no |
| <a name="input_eks_desired_size"></a> [eks\_desired\_size](#input\_eks\_desired\_size) | The asg desired size value. | `number` | `3` | no |
| <a name="input_eks_instance_type"></a> [eks\_instance\_type](#input\_eks\_instance\_type) | EKS instance types. | `string` | `"t3.medium"` | no |
| <a name="input_eks_max_size"></a> [eks\_max\_size](#input\_eks\_max\_size) | The asg max size value. | `number` | `5` | no |
| <a name="input_eks_min_size"></a> [eks\_min\_size](#input\_eks\_min\_size) | The asg min size value. | `number` | `3` | no |
| <a name="input_eks_version"></a> [eks\_version](#input\_eks\_version) | EKS version. | `string` | `"1.29"` | no |
| <a name="input_eks_workers_iam_policies"></a> [eks\_workers\_iam\_policies](#input\_eks\_workers\_iam\_policies) | IAM policies to be associated to the workers. | `map(string)` | <pre>{<br/>  "AmazonEBSCSIDriverPolicy": "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy",<br/>  "AmazonEC2ContainerRegistryReadOnly": "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",<br/>  "AmazonSSMManagedInstanceCore": "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"<br/>}</pre> | no |
| <a name="input_elasticache_enabled"></a> [elasticache\_enabled](#input\_elasticache\_enabled) | Deploys and use elasticache memcached for loki cache. | `bool` | `false` | no |
| <a name="input_elasticache_instance_type"></a> [elasticache\_instance\_type](#input\_elasticache\_instance\_type) | The elasticache instance type. | `string` | `"cache.t3.small"` | no |
| <a name="input_elasticache_nodes"></a> [elasticache\_nodes](#input\_elasticache\_nodes) | The number of cache nodes in elasticache. | `number` | `1` | no |
| <a name="input_elasticache_parameter_group_name"></a> [elasticache\_parameter\_group\_name](#input\_elasticache\_parameter\_group\_name) | The elasticache parameter group name. | `string` | `"default.memcached1.6"` | no |
| <a name="input_elasticache_port_number"></a> [elasticache\_port\_number](#input\_elasticache\_port\_number) | The elasticache port number. | `number` | `11211` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | `"dev"` | no |
| <a name="input_loki_log_retention"></a> [loki\_log\_retention](#input\_loki\_log\_retention) | The grafana loki log retention in hours. | `string` | `"720h"` | no |
| <a name="input_loki_namespace"></a> [loki\_namespace](#input\_loki\_namespace) | The namespace where loki should be deployed. | `string` | `"observability"` | no |
| <a name="input_loki_release_name"></a> [loki\_release\_name](#input\_loki\_release\_name) | The grafana loki helm release name. | `string` | `"grafana-loki"` | no |
| <a name="input_loki_version"></a> [loki\_version](#input\_loki\_version) | The kube prometheus stack helm chart version. | `string` | `"6.7.1"` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Name to identify the project name in tags, descriptions, etc. | `string` | `"loki-stack"` | no |
| <a name="input_prometheus_namespace"></a> [prometheus\_namespace](#input\_prometheus\_namespace) | The namespace where prometheus should be deployed. | `string` | `"observability"` | no |
| <a name="input_prometheus_release_name"></a> [prometheus\_release\_name](#input\_prometheus\_release\_name) | The prometheus helm release name. | `string` | `"kube-prometheus-stack"` | no |
| <a name="input_prometheus_version"></a> [prometheus\_version](#input\_prometheus\_version) | The kube prometheus stack helm chart version. | `string` | `"61.7.0"` | no |
| <a name="input_promtail_namespace"></a> [promtail\_namespace](#input\_promtail\_namespace) | The namespace where promtail should be deployed. | `string` | `"observability"` | no |
| <a name="input_promtail_release_name"></a> [promtail\_release\_name](#input\_promtail\_release\_name) | The grafana promtail helm release name. | `string` | `"grafana-promtail"` | no |
| <a name="input_promtail_version"></a> [promtail\_version](#input\_promtail\_version) | The grafana promtail helm chart version. | `string` | `"6.16.4"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS region. | `string` | `"eu-west-2"` | no |
| <a name="input_vpc_cidr"></a> [vpc\_cidr](#input\_vpc\_cidr) | VPC CIDR. | `string` | `"10.0.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_cluster_cmd"></a> [access\_cluster\_cmd](#output\_access\_cluster\_cmd) | n/a |
| <a name="output_account_id"></a> [account\_id](#output\_account\_id) | n/a |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_memcached_endpoint"></a> [memcached\_endpoint](#output\_memcached\_endpoint) | n/a |
