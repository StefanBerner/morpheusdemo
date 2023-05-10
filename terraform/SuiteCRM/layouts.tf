
resource "morpheus_instance_layout" "LO_SUITE_CRM_APP_MN" {
  instance_type_id = morpheus_instance_type.SUITE_CRM_APP_MN.id
  name             = "LO_SUITE_CRM_APP_MN"
  version          = "Latest"
  technology       = "vmware"
  node_type_ids = [
    morpheus_node_type.NODE_SUITE_CRM_APP_MN.id
  ]
  option_type_ids    = [morpheus_text_option_type.SuiteCRMDBName.id, morpheus_password_option_type.SuiteCRMDBPassword.id,morpheus_text_option_type.SuiteCRMDBUser.id]
  workflow_id = morpheus_provisioning_workflow.SuiteCRMAPPMN.id
}
resource "morpheus_instance_layout" "LO_SUITE_CRM_DB_MN" {
  instance_type_id = morpheus_instance_type.SUITE_CRM_DB_MN.id
  name             = "LO_SUITE_CRM_DB_MN"
  version          = "Latest"
  technology       = "vmware"
  node_type_ids = [
    morpheus_node_type.NODE_SUITE_CRM_DB_MN.id
  ]
  option_type_ids    = [morpheus_text_option_type.SuiteCRMDBName.id, morpheus_password_option_type.SuiteCRMDBPassword.id,morpheus_text_option_type.SuiteCRMDBUser.id]
  workflow_id = morpheus_provisioning_workflow.SuiteCRMDBMN.id
}