resource "morpheus_text_option_type" "SuiteCRMDBName" {
  name               = "SuiteCRM DB Name"
  field_name         = "databaseNameSCRM"
  field_label        = "SuiteCRM DB Name"
  require_field      = "true"
  required           = "true"
}
resource "morpheus_password_option_type" "SuiteCRMDBPassword" {
  name               = "SuiteCRM DB Password"
  field_name         = "databasePassSCRM"
  field_label        = "SuiteCRM DB Password"
  require_field      = "true"
  required           = "true"
}
resource "morpheus_text_option_type" "SuiteCRMDBUser" {
  name               = "SuiteCRM DB User"
  field_name         = "databaseUserSCRM"
  field_label        = "SuiteCRM DB User"
  require_field      = "true"
  required           = "true"
}
