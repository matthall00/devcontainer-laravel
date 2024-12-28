FROM serversideup/php:8.2-fpm

USER root
# Install git and the GitHub CLI (gh), and their dependencies.
# Note that curl and gpg are installed here because they are
# required for the installation of gh.
RUN true \
    && apt-get update && apt-get install -y \
    curl \
    gpg \
    git \
    && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt-get update && apt-get install -y gh \
    && rm -rf /var/lib/apt/lists/* \
    && true
USER www-data

WORKDIR /workspace
