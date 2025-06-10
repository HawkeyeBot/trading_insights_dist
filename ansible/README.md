# Automated installation using Ansible

This readme-file will walk you through the automated deployment of the Trading Insights dashboard.
All commands are assumed to be executed from the root of the trading_insights repository

## Prerequisites

1) Ansible is installed
2) Python is installed
3) The trading_insights repository is checked out locally
4) Your local machine's public key is added to hetzner with the alias `trading-insights-key`

## Configuration

By default when you check out the repository, there will be a config.example.json and a config1.example json.
The ansible scripts allows the automated setup of multiple independent scrapers all connecting to a central postgres database.
This allows the setup to serve much more accounts than would be possible if all accounts were running on 1 scraper due
to exchange API limits.

In order to configure the dashboard and scraper(s), start by copying the config.example.json to config.example json:
``cp config.example.json config.json``

After this, you can modify the config.json file as needed. By default it contains 1 scraper instance, but that can be removed if desired int he docker-compose.yml.

The next step is to copy the config1.example.json to config1.json: ``cp config1.example.json config1.json``.
After this, you can modify the config1.json file as needed. It's generally advised to limit 1 scraper instance to about 3 or 4 accounts max to prevent rate limiting issues.

If you want to set up more scraper instances, simply create more config<n>.json files: ``cp config1.example.json config2.json``.

If you want to have the API-keys whitelisted with the IPs of the scraper, you'll have to generate the API keys first on the exchange without whitelisting.
Then once the servers are created, you can add the IP of the created servers to the key whitelisting.

## Setup

From the root of the trading_insights repository, change the folder to ansible: 

``cd ansible``

Install the necessary requirements: 

``pip3 install -r requirements.txt``

The ansible playbook will create all necessary resources on a hetzner account. For this, you will need an API token ready to provide to the script.

To run the installation, use the following command:

``ansible-playbook multi-scraper.yaml``

At startup of the playbook, you'll be asked to provide the API key.

During installation, the script will automatically create a server and start to SSH into it. During this process,
you'll be asked to accept the server's public key into the known_hosts list. Simply enter `yes` to continue.

## Uninstall

To remove the dashboard, you can use the following commands (assuming the root of trading_insights repository as starting folder):

```
cd ansible
ansible-playbook remove-multi-scraper.yaml
```