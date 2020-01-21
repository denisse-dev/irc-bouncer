<div align="center">

![banner](banner.png)

# Hardened ZNC IRC bouncer with Tor

![forthebadge](https://forthebadge.com/images/badges/built-with-love.svg)
![forthebadge](https://forthebadge.com/images/badges/made-with-crayons.svg)
</div>

## About:

This repository creates a Hardened ZNC IRC Bouncer that uses Tor to connect to IRC networks like Freenode or OFTC.
Some of the information used to automate the creation of the IRC bouncer was taken from the amazing Tom Busby's article [Setting Up a ZNC IRC Bouncer to Use Tor](https://tom.busby.ninja/setting-up-znc-IRC-bouncer-to-use-tor/).

**ZNC**: [ZNC](https://wiki.znc.in/ZNC) is an advanced [IRC bouncer](http://en.wikipedia.org/wiki/BNC_%28software%29#IRC) that is left connected so an IRC client can disconnect/reconnect without losing the chat session. The configuration used in this repository allows multiple clients to connect to the ZNC server.

**Tor**: [Tor](https://www.torproject.org) enables anonymous communication by directing internet traffic through a free, worldwide, volunteer [overlay network](https://en.wikipedia.org/wiki/Overlay_network). The configuration in this repository forces ZNC's traffic to through the Tor network by using Proxychains so the IP address of the ZNC server remains hidden when connecting to IRC networks.

**Proxychains**: [Proxychains](https://github.com/rofl0r/proxychains-ng) preloader which hooks calls to sockets in dynamically linked programs and redirects it through one or more socks/http proxies. It is used in this repository to force ZNC to use the Tor network.

**Firewalld**: [Firewalld](https://firewalld.org/) provides a dynamically managed firewall with support for network/firewall zones that define the trust level of network connections or interfaces. It has support for IPv4, IPv6 firewall settings, ethernet bridges and IP sets. The configuration in this repository opens ports required for ZNC, SSH and Tor to work correctly.

**Packer**: [Packer](https://www.packer.io) is tool for creating identical machine images for multiple platforms from a single source configuration. A machine image is a single static unit that contains a pre-configured operating system and installed software which is used to quickly create new running machines. The configuration in this repository creates an [AMI](https://en.wikipedia.org/wiki/Amazon_Machine_Image) with ZNC, Tor, Proxychains and Firewalld installed and automates the configuration of these tools to work correctly.

**Terraform**: [Terraform](https://www.terraform.io/) is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions. The configuration in this repository creates an AWS EC2 t3.micro instance where the bouncer will be installed.

**AWS Free Tier**: The [AWS Free Tier](https://aws.amazon.com/free/) provides customers the ability to explore and try out AWS services free of charge up to specified limits for each service. The Free Tier is comprised of three different types of offerings, a 12-month Free Tier, an Always Free offer, and short term trials. The configuration in this repository allows you to have a free IRC bouncer for a whole year!

---

## Usage:

1. Configure the [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
2. Install `packer` and `terraform` (ex. `pacman -S packer terraform`).
3. Create the AMI `packer build`.

   **Note**: The **TOTP** for SSH configuration is executed during the hardening provisioner of `packer build`, you'll see some lines like this:

   ```bash
   ZNC IRC Bouncer: Do you want authentication tokens to be time-based (y/n) Warning: pasting the following URL into your browser exposes the OTP secret to Google:
   ZNC IRC Bouncer:   https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=otpauth://totp/bouncie@ip-172-31-38-69.ec2.internal%3Fsecret%3DDYDTZEOXL2J3QIDIRHSRHFLNEI%26issuer%3Dip-172-31-38-69.ec2.internal
   ZNC IRC Bouncer: Your new secret key is: DYDTZEOXL2J3QIDIRHSRHFLNEI
   ZNC IRC Bouncer: Your verification code is 450150
   ZNC IRC Bouncer: Your emergency scratch codes are:
   ZNC IRC Bouncer:   76788027
   ZNC IRC Bouncer:   81328705
   ZNC IRC Bouncer:   80540821
   ZNC IRC Bouncer:   37103827
   ZNC IRC Bouncer:   66794067
   ```

   Make sure to store the emergency scracth codes in a safe place and add the OTP secret to your 2FA application, I suggest using [Authy](https://authy.com/) for this.

   If you don't do this you won't be able to SSH into the instance.
4. Export the `TF_VAR_ami_id` environment variable with the AMI-ID of the Machine you've just created (ex. `export TF_VAR_ami_id=<ami id>`).
5. Run `terraform apply`.
6. Once it has been deployed continue to the configuration section.

## Configuration (WIP):

1. Upon first login you should set up a password for the `bouncie` user.

## Next steps:

1. Add TOTP for SSH (Password logins are disabled already, I just want to set up TOTP using Linux PAM for fun).
2. Configure SELinux.
3. Probably make ZNC's dashboard accesible only when using Tor.
4. Probably configure fail2ban.
