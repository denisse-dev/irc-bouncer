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
set +o history # unset bash history
unset HISTFILE # unset zsh history

export PKR_VAR_linode_token=<linode token>
export PKR_VAR_user=<instance user>
export PKR_VAR_ssh_keys=<url with public keys>
export PKR_VAR_control_pass=<tor's control password>
```

2. To install packer plugins:

```bash
packer init packer
```

3. To build an image:

```bash
packer build packer
```

The following variables are shown in STDOUT and are required for the next steps:

1. **znc_cert_fingerprint**
1. **liberachat_fingerprint**
1. **oftc_fingerprint**
1. **hidden_service**
1. **linode_image**

<div align="center">

![Screenshot of Ansible's output showing three certificate variables ](img/fingerprints.svg)

</div>

# Deploy image

1. To export Terraform variables:

```bash
set +o history # unset bash history
unset HISTFILE # unset zsh history

export TF_VAR_linode_token=<your linode token>
export TF_VAR_image=<linode image id>
```

2. To deploy an instance

```bash
terraform -chdir=terraform init
terraform -chdir=terraform apply
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

# Access ZNC's webadmin

1. To get the Onion Service URL:

```bash
cat /var/lib/tor/hidden_service/hostname
```

2. To get ZNC's port

```bash
sed --quiet --expression '/Port/p' /var/lib/znc/.znc/configs/znc.conf
```

3. Access ZNC's webadmin using the onion service and the port, (ex. `http://owgtuxw3dd2m2cyii5nzxk6bohzggragerdvzdsev6uhjyb3cfn2u5yd.onion:15763/`):

![Screenshot showing ZNC's user interface via an Onion Service](img/onion-service.png)
