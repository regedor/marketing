#!/bin/bash

EXPORT RAILS_ENV=production 

# Exit on error
set -e

# Check if database is already set up by looking for an existing table
if bundle exec rails db:exists; then
    echo "Database already exists, running migrations..."
    bundle exec rails db:migrate
else
    echo "Setting up database for the first time..."
    bundle exec rails db:reset
    bundle exec rails db:migrate
fi

# Start the main server process
exec "$@"