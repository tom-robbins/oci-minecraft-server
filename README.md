# OCI Minecraft Server Hosting

This is a simple terraform workspace to set up a minecraft server using free resources in OCI

## Quickstart

- [Sign up for an always free OCI account](https://www.oracle.com/cloud/free/)
- [Set up terraform for OCI](https://docs.oracle.com/en-us/iaas/developer-tutorials/tutorials/tf-provider/01-summary.htm) - you only need to follow the steps in the first section ("Prepare")
- populate TF_VAR_OCI shell variables (in a ~/.bashrc or ~/.zshrc file) and add to your terminal session

```
# OCI / TERRAFORM
export TF_VAR_OCI_TENANCY="..."
export TF_VAR_OCI_TENANCY_OCID="..."
export TF_VAR_OCI_USER_OCID="..."
export TF_VAR_OCI_PRIVATE_KEY_PATH="..."
export TF_VAR_OCI_PUBLIC_KEY_PATH="..."
export TF_VAR_OCI_FINGERPRINT="..."
```

- Create the infrastructure by running `cd terraform && terraform apply` - the server should be up in about 10 minutes
- [Go to the console](https://cloud.oracle.com/compute/instances) and find your instance's public IP
- Add the minecraft server in your client with address <IP>:25565

## Next Steps

- SSH into the server to debug or [customize](https://minecraft.fandom.com/wiki/Tutorials/Setting_up_a_server) the server

## Troubleshooting

- ssh into the server and view the cloud-init logs. Search for lines prefixed with "cloud-init:" for errors in the init script

```
ssh -i $TF_VAR_OCI_PRIVATE_KEY_PATH opc@<IP>
sudo less /var/log/messages
```
