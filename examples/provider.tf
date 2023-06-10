provider "oci" {
  config_file_profile = "PROFILE_NAME"

  ignore_defined_tags = ["Oracle-Tags.CreatedBy", "Oracle-Tags.CreatedOn"]
}