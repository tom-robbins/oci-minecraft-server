locals {
  shape = "VM.Standard.A1.Flex"
}

# get latest Oracle Linux 7.9 image
data "oci_core_images" "oraclelinux" {
  compartment_id           = oci_identity_compartment.compartment.id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  shape                    = local.shape
}

resource "oci_core_instance" "ubuntu_instance" {
  compartment_id      = oci_identity_compartment.compartment.id
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  shape               = local.shape
  shape_config {
    baseline_ocpu_utilization = "BASELINE_1_1"
    memory_in_gbs             = var.memory
    ocpus                     = var.cpus
  }

  source_details {
    source_id   = data.oci_core_images.oraclelinux.images[0].id
    source_type = "image"
  }

  display_name = var.NAME
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.vcn-public-subnet.id
  }
  metadata = {
    ssh_authorized_keys = file(var.OCI_PUBLIC_KEY_PATH)
    user_data           = "${base64encode(file("./cloud-init.sh"))}"
  }
  preserve_boot_volume = false
}
