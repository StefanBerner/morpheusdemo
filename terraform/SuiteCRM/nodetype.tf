data "morpheus_virtual_image" "suitecrm-image" {
  name = "Ubuntu 22.04"
// image_type will be part of the next provider release
//  imagetype = "vmware"
}
resource "morpheus_node_type" "NODE_SUITE_CRM_APP_MN" {
  name             = "NODE_SUITE_CRM_APP_MN"
  short_name       = "nodesuitecrmappmn"
  technology       = "vmware"
  version          = "Latest"
  virtual_image_id = data.morpheus_virtual_image.suitecrm-image.id
}
resource "morpheus_node_type" "NODE_SUITE_CRM_DB_MN" {
  name             = "NODE_SUITE_CRM_DB_MN"
  short_name       = "nodesuitecrmdbmn"
  technology       = "vmware"
  version          = "Latest"
  virtual_image_id = data.morpheus_virtual_image.suitecrm-image.id
}
