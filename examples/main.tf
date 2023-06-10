// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

module "groups_users" {
  source = "../"

  tenancy_ocid        = var.tenancy_ocid
  groups_users_config = var.groups_users_config
}