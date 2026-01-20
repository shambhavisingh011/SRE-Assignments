
# Multi-Master SaltStack Failover Architecture

## Project Overview
This project demonstrates a highly available infrastructure using SaltStack to manage an Nginx web server. The setup includes two Salt Masters for failover redundancy and a Salt Minion configured to receive states and pillar data from either master.

## Architecture
 - **Primary Master**: salt-master (Multipass Ubuntu VM)

 - **Failover Master**: secondary-master (Multipass Ubuntu VM)

 - **Minion**: salt-minion (Nginx Web Server)

 ## Multipass setup

 To simulate a local data center, three VMs were initialized:
  ```
multipass launch --name salt-master
multipass launch --name secondary-master
multipass launch --name salt-minion
  ```

  ## Salt Setup 

  ```
# Create keyring directory
sudo mkdir -p /etc/apt/keyrings

# Download Salt Project Key
curl -fsSL https://packages.broadcom.com/artifactory/api/security/keypair/SaltProjectKey/public | sudo tee /etc/apt/keyrings/salt-archive-keyring.pgp

# Add Salt sources
curl -fsSL https://github.com/saltstack/salt-install-guide/releases/latest/download/salt.sources | sudo tee /etc/apt/sources.list.d/salt.sources

# Pin the version to 3006
echo 'Package: salt-*
Pin: version 3006.*
Pin-Priority: 1001' | sudo tee /etc/apt/preferences.d/salt-pin-1001

sudo apt update

  ```

## Validation (How to Test)

Failover Test

- Step 1: Apply states from the Primary Master: salt '*' state.apply.

- Step 2: Stop the Primary Master VM: multipass stop salt-master.

- Step 3: Trigger a state apply from the Minion: salt-call state.apply.

- Result: The Minion automatically identifies that Master-1 is down and pulls the configuration from secondary-master.


## Web Server Verification
For **primary master** - 

- Open your browser and navigate to: http://<minion-01-IP-address>

For **secondary master** - 

- Open your browser and navigate to: http://<minion-01-IP-address>


