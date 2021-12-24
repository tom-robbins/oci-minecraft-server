variable "NAME" {
  description = "The name of the minecraft server"
  type        = string
  default     = "minecraft"
}

# From your user avatar, go to Tenancy:<your-tenancy> and copy OCID.
variable "OCI_TENANCY_OCID" {
  description = "tenancy id where to create the sources"
  type        = string
}

# From your user avatar, go to User Settings and copy OCID
variable "OCI_USER_OCID" {
  description = "id of user that terraform will use to create the resources"
  type        = string
}

# From your user avatar, go to User Settings and click API Keys.
# Copy the fingerprint associated with the RSA public key you made in section 2. The format is: xx:xx:xx...xx.
variable "OCI_FINGERPRINT" {
  description = "fingerprint of oci api private key"
  type        = string
}

# From the top navigation bar, find your region.
# Find your region's <region-identifier> from Regions and Availability Domains. Example: us-ashburn-1.
variable "OCI_REGION" {
  description = "OCI Region"
  type        = string
  default     = "us-sanjose-1"
}

# Path to the RSA public key you made in the Create RSA Keys section. Example: $HOME/.oci/<your-rsa-key-name>.pem.
variable "OCI_PUBLIC_KEY_PATH" {
  description = "path to oci api public key used"
  type        = string
}

# Path to the RSA private key you made in the Create RSA Keys section. Example: $HOME/.oci/<your-rsa-key-name>.pem.
variable "OCI_PRIVATE_KEY_PATH" {
  description = "path to oci api private key used"
  type        = string
}

variable "memory" {
  description = "Amount of memory to provision (in GBs)"
  type        = number
  default     = 8
}

variable "cpus" {
  description = "Amount of CPUs to provision"
  type        = number
  default     = 2
}