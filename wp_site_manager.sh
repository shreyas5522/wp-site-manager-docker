#!/bin/bash

# Function to check if a command is available
function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Docker and Docker Compose
function install_dependencies() {
    echo "Installing Docker and Docker Compose..."
    # Install Docker
    if ! command_exists docker; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo usermod -aG docker "$USER"
        rm get-docker.sh
    fi

    # Install Docker Compose
    if ! command_exists docker-compose; then
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    echo "Docker and Docker Compose are installed."
}

# Function to create a new WordPress site
function create_wordpress_site() {
    local site_name="$1"
    echo "Creating WordPress site: $site_name"

    # Create docker-compose.yml
    cat <<EOF >docker-compose.yml
version: '3'
services:
  wordpress:
    image: wordpress:latest
    ports:
      - "80:80"
    environment:
      WORDPRESS_DB_HOST: db
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
    volumes:
      - wordpress:/var/www/html
    depends_on:
      - db
    restart: always
  db:
    image: mariadb:latest
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    volumes:
      - db:/var/lib/mysql
volumes:
  wordpress:
  db:
EOF

    # Create /etc/hosts entry
    sudo sh -c "echo '127.0.0.1 $site_name' >> /etc/hosts"

    # Start the containers
    docker-compose up -d

    echo "WordPress site $site_name is up and running!"
    echo "You can access it at http://$site_name"

    # Open in browser
    xdg-open "http://$site_name" >/dev/null 2>&1 || open "http://$site_name" >/dev/null 2>&1 || echo "Please open http://$site_name in your browser."

}

# Function to enable/disable the WordPress site
function manage_site() {
    local site_name="$1"
    local action="$2"

    case $action in
    enable)
        echo "Enabling WordPress site: $site_name"
        docker-compose -f "docker-compose.yml" up -d
        ;;
    disable)
        echo "Disabling WordPress site: $site_name"
        docker-compose -f "docker-compose.yml" stop
        ;;
    esac
}

# Function to delete the WordPress site
function delete_site() {
    local site_name="$1"
    echo "Deleting WordPress site: $site_name"
    docker-compose -f "docker-compose.yml" down --volumes
    sudo sed -i "/^127.0.0.1 $site_name/d" /etc/hosts
    echo "WordPress site $site_name has been deleted."
}

# Check if Docker and Docker Compose are installed
if ! command_exists docker || ! command_exists docker-compose; then
    install_dependencies
fi

# Main script
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <subcommand> [site_name]"
    echo "Available subcommands: create, manage, delete"
    exit 1
fi

subcommand="$1"
site_name="$2"

case $subcommand in
create)
    create_wordpress_site "$site_name"
    ;;
manage)
    action="$3"
    if [[ -z $action ]]; then
        echo "Usage: $0 manage <site_name> <enable/disable>"
        exit 1
    fi
    manage_site "$site_name" "$action"
    ;;
delete)
    delete_site "$site_name"
    ;;
*)
    echo "Invalid subcommand: $subcommand"
    echo "Available subcommands: create, manage, delete"
    exit 1
    ;;
esac

