
##########################################
# Cloud Config 
##########################################
#####################
# Delivery Channel
#####################
# OSS
resource "alicloud_oss_bucket" "oss_cloud_config" {
  bucket = "hnkl-oss-cloudconfig"
  acl    = "private"
}


## Delivery Channel > Alicloud Provider missing resource
resource "alicloud_config_delivery_channel" "cc_channel" {
  delivery_channel_name = "hnkl_delivery_channel"
  delivery_channel_assume_role_arn = "acs:ram::cloudconfig:role/aliyunserviceroleforconfig"
  delivery_channel_type = "OSS"
  delivery_channel_target_arn = format("acs:oss:ap-southeast-1:*:${alicloud_oss_bucket.oss_cloud_config.bucket}")
}


#####################
# Cloud Config Rules
#####################
resource "alicloud_config_configuration_recorder" "cc_recorder" {
  resource_types = [
    "ACS::ECS::Instance",
    "ACS::ECS::Disk"
  ]
}

resource "alicloud_config_rule" "cc_rule" {
  rule_name                       = "ecs-compliance"
  source_identifier               = "ecs-instances-in-vpc"
  source_owner                    = "ALIYUN"
  scope_compliance_resource_types = ["ACS::ECS::Instance"]
  description                     = "ecs instances in vpc"

  risk_level                         = 1
  source_detail_message_type         = "ConfigurationItemChangeNotification"
  source_maximum_execution_frequency = "Twelve_Hours"

}
