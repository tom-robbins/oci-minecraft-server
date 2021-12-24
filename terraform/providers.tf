provider "oci" {
  tenancy_ocid     = var.OCI_TENANCY_OCID
  user_ocid        = var.OCI_USER_OCID
  private_key_path = var.OCI_PRIVATE_KEY_PATH
  fingerprint      = var.OCI_FINGERPRINT
  region           = var.OCI_REGION
}
