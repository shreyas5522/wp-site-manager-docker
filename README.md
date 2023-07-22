# WordPress Site Manager DOCKER [- LEMP]

WordPress Site Manager is a command-line script written in Bash that allows you to easily manage WordPress sites using Docker containers in a LEMP stack (Linux, Nginx, MariaDB, PHP). The script helps you create, manage (enable/disable), and delete WordPress sites on your local development environment.

## Prerequisites

Before using this script, ensure you have the following software installed on your system:
- Linux System [preferability ubuntu]
- Docker
- Docker Compose

## Installation

1. Clone this repository to your local machine:

```bash
git clone https://github.com/shreyas5522/wp-site-manager.git
```
2. Change directory to the project folder:
```bash
cd wp-site-manager
```
3. Make the script executable:
```bash
chmod +x wp_site_manager.sh
```
## Usage
Run the script with the following subcommands:

1. Create a new WordPress site
To create a new WordPress site, use the `create` subcommand followed by the desired site name:
```bash
./wp_site_manager.sh create example.com
```
2. Enable/Disable a WordPress site
To enable or disable a WordPress site, use the manage subcommand followed by the site name and the action (enable or disable):
```bash
# Enable the Site:
./wp_site_manager.sh manage example.com enable
```

```bash
# Disable the Site:
./wp_site_manager.sh manage example.com disable
```

3. Delete a WordPress site
To delete a WordPress site and its associated containers and volumes, use the delete subcommand followed by the site name:
```bash
./wp_site_manager.sh delete example.com
```

4. Uninstall Docker and Docker Compose
To uninstall Docker and Docker Compose from your system, use the uninstall subcommand:
```bash
./wp_site_manager.sh uninstall
```

## Note

- This script assumes that you have the necessary permissions to execute Docker commands and modify `/etc/hosts`.
- Make sure you don't have any other services running on port 80 since the WordPress container will bind to this port.
- Consider using a development domain (like `example.local`) instead of `example.com` if you're working on a live environment to avoid conflicts with real domains.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.


