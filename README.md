# Laravel DevContainer Starter

This repository is a template for quickly starting a new Laravel project in a VSCode devcontainer. It includes an interactive setup script for Laravel installation and optional database configuration, allowing flexibility for custom setups.

## Project Overview

- **Base Environment**: PHP 8.2 with Composer pre-installed.
- **Interactive Laravel Installation**: The `init-laravel.sh` script allows for interactive setup of a Laravel project with the following features:
  - Specify a project name.
  - Optional configuration of database credentials.
  - Laravel installation via Composer if not already present.
  - Automatic generation of the application key.
- **Docker Setup**: Minimal by default (no database service).
  - Includes a pre-configured `docker-compose.yml` for running a PHP service.
- **Devcontainer Configuration**: Fully configured for VSCode Remote - Containers.

## Directory Structure

```
devcontainer-laravel-starter/
├── .devcontainer/
│   ├── devcontainer.json
│   ├── docker-compose.yml
│   ├── Dockerfile
│   ├── init-laravel.sh
├── .gitignore
├── README.md
```

### File Details

#### `.devcontainer/Dockerfile`

Defines the base image for the Laravel app container:

- Uses `php:8.2-fpm`.
- Installs required PHP extensions: `pdo_mysql`, `pdo_pgsql`, `mbstring`, `zip`.
- Includes Composer for package management.

#### `.devcontainer/docker-compose.yml`

Configures the `app` service:

- Maps the local directory to `/workspace` in the container.
- Exposes port `8000` for Laravel's development server.

#### `.devcontainer/devcontainer.json`

Defines the devcontainer setup:

- Launches the `init-laravel.sh` script post-container creation.
- Pre-installs useful VSCode extensions like Intelephense and Dotenv.

#### `.devcontainer/init-laravel.sh`

An interactive Bash script:

- Prompts for a Laravel project name.
- Allows optional configuration of database settings.
- Creates a Laravel project if not present and generates an app key.

#### `.gitignore`

Excludes unnecessary files:

- `vendor`
- `.env`
- `node_modules`
- PHPUnit caches and temporary files.

#### `README.md`

Provides detailed usage instructions for setting up and using the repository.

## Usage Instructions

1. **Clone this repository**:

   ```bash
   git clone https://github.com/your-username/devcontainer-laravel-starter.git
   cd devcontainer-laravel-starter
   ```

2. **Open in VSCode**:

   - Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
   - Open the repository and reopen it in the devcontainer when prompted.

3. **Interactive Setup**:

   - The `init-laravel.sh` script will guide you through project creation.
   - Provide a Laravel project name and optionally configure database credentials.

4. **Start Development**:
   ```bash
   php artisan serve --host=0.0.0.0 --port=8000
   ```

## Customization Options

### Adding a Database Service

To include a database (e.g., MySQL):

1. Add the following to `docker-compose.yml`:

   ```yaml
   db:
     image: mysql:8.0
     environment:
       MYSQL_ROOT_PASSWORD: secret
       MYSQL_DATABASE: laravel
     ports:
       - "3306:3306"
   ```

2. Update the `.env` file with database credentials.

### Reusing for Existing Projects

This setup works for existing Laravel projects. Clone or copy your project into `/workspace` after setting up the container.

## Contributions

Fork this repository to customize or improve the setup! Submit pull requests to share your improvements.
