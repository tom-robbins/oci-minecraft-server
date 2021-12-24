# Source from https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.OCI_TENANCY_OCID
}

module "vcn" {
  source         = "oracle-terraform-modules/vcn/oci"
  version        = "3.1.0"
  compartment_id = oci_identity_compartment.compartment.id
  label_prefix   = var.NAME
  vcn_name       = "vcn"
  vcn_dns_label  = var.NAME
  vcn_cidrs      = ["10.0.0.0/16"]

  create_internet_gateway       = true
  internet_gateway_display_name = var.NAME
  #   create_nat_gateway = true
  #   nat_gateway_display_name = var.NAME
  #   create_service_gateway = true
  #   service_gateway_display_name = var.NAME
}


resource "oci_core_security_list" "private-security-list" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.NAME}-private-subnet-security-list"
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "6"
    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
    }
  }
}

resource "oci_core_security_list" "public-security-list" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.NAME}-public-subnet-security-list"
  egress_security_rules {
    stateless        = false
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
  }
  # SSH access
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 22
      max = 22
    }
  }
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
      code = 4
    }
  }

  ingress_security_rules {
    stateless   = false
    source      = "10.0.0.0/16"
    source_type = "CIDR_BLOCK"
    protocol    = "1"
    icmp_options {
      type = 3
    }
  }
  # Minecraft ports
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "6" # TCP
    tcp_options {
      min = 25565
      max = 25565
    }
  }
  ingress_security_rules {
    stateless   = false
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    protocol    = "17" # UDP
    udp_options {
      min = 25565
      max = 25565

    }
  }

}

# resource "oci_core_subnet" "vcn-private-subnet"{
#   compartment_id = oci_identity_compartment.compartment.id
#   vcn_id = module.vcn.vcn_id
#   cidr_block = "10.0.1.0/24"
#   route_table_id = module.vcn.nat_route_id
#   security_list_ids = [oci_core_security_list.private-security-list.id]
#   display_name = "${var.NAME}-private-subnet"
# }

resource "oci_core_subnet" "vcn-public-subnet" {
  compartment_id    = oci_identity_compartment.compartment.id
  vcn_id            = module.vcn.vcn_id
  cidr_block        = "10.0.0.0/24"
  route_table_id    = module.vcn.ig_route_id
  security_list_ids = [oci_core_security_list.public-security-list.id]
  display_name      = "${var.NAME}-public-subnet"
}

resource "oci_core_dhcp_options" "dhcp-options" {
  compartment_id = oci_identity_compartment.compartment.id
  vcn_id         = module.vcn.vcn_id
  options {
    type        = "DomainNameServer"
    server_type = "VcnLocalPlusInternet"
  }
  display_name = "${var.NAME}-dhcp-options"
}
