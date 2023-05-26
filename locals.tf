locals {
  uuid                       = random_uuid.cluster.result
  timestamp                  = time_static.timestamp.unix
  deployment_id              = length(var.deployment_prefix) > 0 ? var.deployment_prefix : "redpanda-${substr(local.uuid, 0, 8)}-${local.timestamp}"
  tiered_storage_bucket_name = replace("${local.deployment_id}-bucket", "_", "-")

  # tags shared by all instances
  instance_tags = {
    owner : local.deployment_id
    iam_username : trimprefix(data.aws_arn.caller_arn.resource, "user/")
  }

  merged_tags = merge(local.instance_tags, var.tags)
  node_details = [
    for index, instance in aws_instance.redpanda :
    {
      instance_id : instance.id
      public_ip : instance.public_ip
      private_ip : instance.private_ip
      name : "${var.deployment_prefix}-node-${index}"
    }
  ]
}