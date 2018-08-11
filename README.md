# Concourse Single Instance AMI

AMI that should be used to create virtual machines with Concourse CI installed

## Synopsis

This project will create an AMI with Concourse CI installed and with Postgresql database.

The AMI resulting from this script should be the one used to instantiate a CI server (standalone)

## Getting Started

There are a couple of things needed for the script to work.

### Prerequisites

Packer need to be installed on your local computer or CI server.
To build a base image you have to know the id of the latest Ubuntu AMI files for the region where you wish to build the AMI.

AMI-IDs for other regions can be found by using [Ubuntu's AMI locator](https://cloud-images.ubuntu.com/locator/ec2/) and selecting the `14.04 LTS hvm:ebs-ssd` image for the desired region.

The project may benefit from usages of isntances with Spot prices.

[Spot prices](https://aws.amazon.com/ec2/spot/pricing/)

- AWS CLI


#### Packer

Packer installation instructions can be found
[here](https://www.packer.io/docs/installation.html).

### Usage

In order to create the AMI using this packer template you need to provide a
few options.

```bash
Usage:
  ./build.sh
```

#### `secrets.json` Options

```json
{
  "concourse_version": "3.14.1",
  "aws_instance_type": "t2.small",
  "concourse_username": "admin",
  "postgress_username": "concourse",
  "postgress_host": "127.0.0.1"
}
```

### Debug

```bash
sudo journalctl -u concourse.service
journalctl -xe | grep concourse
sudo cat /var/log/syslog | grep concourse
```
