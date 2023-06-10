// Copyright (c) 2018, 2021, Oracle and/or its affiliates.

variable "tenancy_ocid" {
  description = "(Required) (Updatable) The OCID of the root compartment."
  type        = string
}

variable "groups_users_config" {
  type = any
}