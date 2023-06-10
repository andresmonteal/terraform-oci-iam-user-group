data "oci_identity_groups" "groups" {
  #Required
  compartment_id = var.tenancy_ocid

  depends_on = [oci_identity_group.groups]
}