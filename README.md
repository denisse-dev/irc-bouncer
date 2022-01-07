# About

This repository contains configuration to deploy a ZNC IRC bouncer via Terraform, Packer and Ansible to Linode.

# Pre requisites

- A [Linode API Token](https://www.linode.com/docs/products/tools/linode-api/guides/get-access-token/) with **Read/Write** access for the **Images** and **Linodes** scopes.
- The following packages:
  - [ansible](https://archlinux.org/packages/community/any/ansible/)
  - [packer](https://archlinux.org/packages/community/x86_64/packer/)
  - [terraform](https://archlinux.org/packages/community/x86_64/terraform/)

# Build image

1. To export Packer variables:

```bash
export PKR_VAR_linode_token=<YOUR LINODE TOKEN>
export PKR_VAR_user=<USER OF THE INSTANCE>
export PKR_VAR_ssh_keys=<PATH TO PUBLIC SSH KEYS>

```

2. To install packer plugins:

```bash
packer init packer
```

3. To build an image:

```bash
packer build packer
```

Take note of the following variables:

- **znc_cert_fingerprint.stdout_lines**
- **liberachat_fingerprint.stdout_lines**
- **oftc_fingerprint.stdout_lines**
- **linode_image**

<div align="center">

![Screenshot of Ansible's output showing three certificate variables ](img/fingerprints.svg)

</div>

# Deploy image

1. To export Terraform variables:

```bash
export TF_VAR_linode_token=<YOUR LINODE TOKEN>
export TF_VAR_image=<LINODE IMAGE ID>
```

2. To deploy an instance

```
cd terraform
terraform init
terraform apply
```

3. To connect to the instance:

```bash
ssh <user>@<ip> -p <port>
```

You're required to set-up your password upon first login:

<div align="center">

![Terminal showing how to set password of the instance user](img/set-password.svg)

</div>

First login:

<div align="center">

![Terminal showing the first SSH login](img/first-login.svg)

</div>
