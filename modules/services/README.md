# Homelab Services
This folder contains the configuration for all services hosted on my Homelab server.

## Cloudflare Tunnel
Cloudflare Tunnel is the main access way for services hosted on the server. By letting Cloudflare manage the domain, I can create new DNS records that map to the local IP address of the server, plus some port. 

## Tailscale
For other services, Tailscale is used to connect to the homelab from anywhere. The Cloudflare Tunnel is mainly used for services that I need from foreign devices, such as my work desktop where Tailscale is not an option. 

As a security feature, Tailscale connections expire after a given period. In order to re-authenticate an already registered device, run `sudo tailscale up --force-reauth`. This will try to re-authenticate the device with the old tailnet, prompting you to open a link and logging in with the admin user.

## Fail2Ban
This service is primarily used to detect brute-force attacks on any service I'm hosting, and to ban IP addresses in such a case.

## Immich
Immich is my open-source replacement for Google Photos. It works incredibly well and is very simple to set up. 

## Minecraft
There is currently one single Minecraft server being hosted, which is for the Divine Journey 2 modpack. I'm using [nixos-modded-minecraft](https://github.com/mkaito/nixos-modded-minecraft-servers) for that, which is a very light flake that allows you to run arbitrary modded Minecraft servers as follows:
1. Download the server files for a modpack
2. Extract all files and check if there is a shell script included that can be used in order to start the server
3. If yes, rename it to `start.sh` and make it executable. If not, create one with roughly the following content: `exec java -server forge-{version_included_in_zip} nogui` with potential Java arguments
4. Create a module with a name under `services.modded-minecraft-servers.instances`
5. This service will create a folder under `/var/lib/mc-<name>`. Put all server files into that folder.
6. After that, the server will be started automoatically as a systemd service

## Nextcloud
Nextcloud is my go-to choice of private file sync and backup service. I use it as a replacement for stuff like OneDrive or Google Drive. The setup includes OnlyOffice.

### OnlyOffice
In order to allow editing files on Nextcloud in the web interface (useful for editing from devices without having the whole drive synced or having to download, edit, and upload again), OnlyOffice acts as a document server for that. The setup works as follows: OnlyOffice is running as a Docker container on the server. It's added to the Nextcloud config, but needs to be authenticated with a token. In order to get the token and set it in Nextcloud's web interface, do the following steps:
1. Run `docker ps` and find the container ID for the OnlyOffice container
2. Run `docker exec -it {container_id} cat /etc/onlyoffice/documentserver/local.json`
3. In the resulting json output, locate the object `secret.inbox.string` and copy the random string there
4. Go to Nextcloud's web interface, navigate to Administration Settings > OnlyOffice and paste the copied string

So far, it seems like it can happen that this token is reset when the docker container unexpectedly shuts down, i.e., when the server crashes and needs to be manually rebooted. 
Update August 2025: I've finally added a predefined JWT to my secrets and added it to the OnlyOffice container via env variable. This ensures that when the container is restarted, we get the same JWT again, so I shouldn't need to udpate it in the NextCloud web interface anymore. 

## nginx
nginx is the proxy service I use to act as the middle man between my services and the outside (or rather, Cloudflare Tunnel). 

## Vaultwarden
Vaultwarden is my open-source password manager for now. 

## Note on Docker Services
While there are many configurations out there that use Docker containers on NixOS directly, this is unfortunately not the case for all services listed here. As a result, the configurations for OnlyOffice and PostgreSQL were auto-generated with the fantastic [compose2nix](https://github.com/aksiksi/compose2nix) tool. This CLI tool takes a Docker compose file, reads it, and produces a nix file that is equivalent to the Docker compose file, but is directly usable on NixOS. It has fantastic options, including generating the container config for Docker or podman, reading extra `.env` files, etc. And it makes configuring containers much simpler because you can run the compose files with a regular Docker Desktop (e.g., on Windwos), test and configure it, then run the file through compose2nix and voilà!
