resource "morpheus_instance_type" "SUITE_CRM_APP_MN" {
  name               = "SUITE_CRM_APP_MN"
  code               = "suitecrmappmn"
 // description        = "Terraform Example Instance Type"
  category           = "apps"
  visibility         = "private"
 // image_path         = "tfexample.png"
//  image_name         = "tfexample.png"
  featured           = false
  enable_deployments = true
  enable_scaling     = true
  enable_settings    = true
  environment_prefix = "SUITECRMAPPMN"
  //option_type_ids    = [morpheus_text_option_type.SuiteCRMDBName.id, morpheus_password_option_type.SuiteCRMDBPassword.id,morpheus_text_option_type.SuiteCRMDBUser.id]
  }
resource "morpheus_instance_type" "SUITE_CRM_DB_MN" {
  name               = "SUITE_CRM_DB_MN"
  code               = "suitecrmdbmn"
 // description        = "Terraform Example Instance Type"
  category           = "apps"
  visibility         = "private"
 // image_path         = "tfexample.png"
//  image_name         = "tfexample.png"
  featured           = false
  enable_deployments = true
  enable_scaling     = true
  enable_settings    = true
  environment_prefix = "SUITECRMDBMN"
  //option_type_ids    = [morpheus_text_option_type.SuiteCRMDBName.id, morpheus_password_option_type.SuiteCRMDBPassword.id,morpheus_text_option_type.SuiteCRMDBUser.id]
  }
