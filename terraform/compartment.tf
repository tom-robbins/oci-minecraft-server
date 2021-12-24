resource "oci_identity_compartment" "compartment" {
  compartment_id = var.OCI_TENANCY_OCID
  description    = "compartment ${var.NAME} managed by terraform"
  name           = var.NAME
}
