// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

########################
# users and groups
########################

locals {
  #################
  # Group and users
  #################
  # default values
  default_group = {
    description = "OCI Identity Group created with the OCI Core IAM Users Groups Module"
  }
  #################
  # Users
  #################
  # default values
  default_user = {
    description = "OCI Identity User created with the OCI Core IAM Users Groups Module"
    email       = null
  }
  default_freeform_tags = {
    terraformed = "Please do not edit manually"
    module      = "oracle-terraform-oci-iam-user-group"
  }
  merged_freeform_tags = merge(var.freeform_tags, local.default_freeform_tags)
  keys_users           = var.groups_users_config != null ? (var.groups_users_config.users != null ? keys(var.groups_users_config.users) : keys({})) : keys({})
  membership           = var.groups_users_config != null ? distinct(flatten(var.groups_users_config.users != null ? [for user_name in local.keys_users : [for group_name in(var.groups_users_config.users[user_name].groups != null ? var.groups_users_config.users[user_name].groups : []) : [{ "user_name" = user_name, "group_name" = group_name }]]] : [])) : []
}

resource "oci_identity_group" "groups" {
  for_each = var.groups_users_config != null ? (var.groups_users_config.groups != null ? var.groups_users_config.groups : {}) : {}
  #Required
  compartment_id = var.tenancy_ocid
  description    = each.value.description != null ? each.value.description : local.default_group.description
  name           = each.key

  #Optional
  defined_tags  = var.defined_tags
  freeform_tags = local.merged_freeform_tags

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "oci_identity_user" "users" {
  for_each = var.groups_users_config != null ? (var.groups_users_config.users != null ? var.groups_users_config.users : {}) : {}
  #Required
  compartment_id = var.tenancy_ocid
  description    = each.value.description != null ? each.value.description : local.default_user.description
  name           = each.key

  #Optional
  defined_tags  = var.defined_tags
  email         = each.value.email != null ? each.value.email : local.default_user.email
  freeform_tags = local.merged_freeform_tags

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
  depends_on = [oci_identity_group.groups]
}

resource "oci_identity_user_group_membership" "users_groups_membership" {
  count = var.groups_users_config != null ? (local.membership != null ? length(local.membership) : 0) : 0

  #Required
  group_id = contains([for group in data.oci_identity_groups.groups.groups : group.name], local.membership[count.index].group_name) == true ? [for group in data.oci_identity_groups.groups.groups : group.id if group.name == local.membership[count.index].group_name][0] : [for group in oci_identity_group.groups : group.id if group.name == local.membership[count.index].group_name][0]
  user_id  = [for user in oci_identity_user.users : user.id if user.name == local.membership[count.index].user_name][0]

  depends_on = [oci_identity_group.groups, oci_identity_user.users]
}