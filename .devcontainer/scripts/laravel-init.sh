#!/bin/bash

# Check if the project is already initialized
if [ ! -d "vendor" ]; then
    composer create-project --prefer-dist laravel/laravel temp
    mv temp/* .
    rm -rf temp

    cp .example.env .env

    php artisan key:generate

    # Replace the current git config lines with these interactive prompts
    echo "Configure Git settings:"
    read -p "Enter your Git name: " gitname
    read -p "Enter your Git email: " gitemail

    git config --global --add safe.directory $PWD
    git config --global init.defaultBranch main
    git config --global user.name "$gitname"
    git config --global user.email "$gitemail"

    read -p "Enter new Git remote URL (leave blank to unset from clone): " -r newRemote
    if [ -z "$newRemote" ]; then
        # Remove remote origin
        git remote remove origin
    else
        git remote set-url origin "$newRemote"
    fi

    echo -e "\n=== Laravel Project Initialized ===\n"

    # Check if user wants to make REST API only and skip frontend. Run the REST API script if so.
    read -p "Make REST API only? (y/n): " -r restapi
    if [[ $restapi =~ ^[Yy]$ ]]; then
        ./.devcontainer/scripts/laravel-rest-api.sh
        exit 0
    fi

    # Check if user wants to install optional packages
    echo -e "\n=== Optional Package Installation ===\n"

    echo "1. Laravel Sanctum - API authentication system"
    echo "   Docs: https://laravel.com/docs/sanctum"
    read -p "Install Sanctum? (y/n): " -r sanctum
    if [[ $sanctum =~ ^[Yy]$ ]]; then
        composer require laravel/sanctum
        php artisan vendor:publish --provider="Laravel\Sanctum\SanctumServiceProvider"
    fi

    echo -e "\n2. Laravel Telescope - Development Debug Assistant"
    echo "   Docs: https://laravel.com/docs/telescope"
    echo "   Provides debugging tools and insights for requests, commands, queries"
    read -p "Install Telescope? (y/n): " -r telescope
    if [[ $telescope =~ ^[Yy]$ ]]; then
        composer require laravel/telescope --dev
        php artisan telescope:install
        php artisan migrate
    fi

    echo -e "\n3. Laravel Passport - Full OAuth2 Server Implementation"
    echo "   Docs: https://laravel.com/docs/passport"
    echo "   Perfect for building OAuth2 APIs with personal access tokens"
    read -p "Install Passport? (y/n): " -r passport
    if [[ $passport =~ ^[Yy]$ ]]; then
        composer require laravel/passport
        php artisan migrate
        php artisan passport:install
    fi

    echo -e "\n4. Laravel Horizon - Redis Queue Monitoring"
    echo "   Docs: https://laravel.com/docs/horizon"
    echo "   Beautiful dashboard and configuration for Redis queues"
    read -p "Install Horizon? (y/n): " -r horizon
    if [[ $horizon =~ ^[Yy]$ ]]; then
        composer require laravel/horizon
        php artisan horizon:install
        php artisan migrate
    fi

    echo -e "\n5. Spatie Permission - Role & Permission Management"
    echo "   Docs: https://spatie.be/docs/laravel-permission"
    echo "   Associate users with roles and permissions"
    read -p "Install Spatie Permission? (y/n): " -r permission
    if [[ $permission =~ ^[Yy]$ ]]; then
        composer require spatie/laravel-permission
        php artisan vendor:publish --provider="Spatie\Permission\PermissionServiceProvider"
        php artisan migrate
    fi

    echo -e "\n6. Laravel Octane - High-Performance Application Server"
    echo "   Docs: https://laravel.com/docs/octane"
    echo "   Supercharge your app with Swoole or RoadRunner"
    read -p "Install Octane? (y/n): " -r octane
    if [[ $octane =~ ^[Yy]$ ]]; then
        composer require laravel/octane

        echo "Select Octane server (1-2):"
        echo "1) Swoole"
        echo "2) RoadRunner"
        read -p "Choice: " -r server_choice

        if [ "$server_choice" == "1" ]; then
            pecl install swoole
            php artisan octane:install --server=swoole
        elif [ "$server_choice" == "2" ]; then
            composer require spiral/roadrunner
            php artisan octane:install --server=roadrunner
        fi
    fi

fi

# Run the Laravel development server
php artisan serve --host=0.0.0.0 --port=8000
