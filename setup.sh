#!/bin/bash

# Check environment and set appropriate variables
if [ "$RAILS_ENV" = "production" ]; then
  echo "Setting up production environment..."
  EXPORT RAILS_ENV=production
else
  echo "Setting up development environment..."
  EXPORT RAILS_ENV=development
fi

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

# Setup cron jobs for Slack notifications based on environment
echo "Setting up notification scheduler..."
if [ "$RAILS_ENV" = "production" ]; then
    bundle exec whenever
else
    bundle exec whenever --update-crontab --set environment=development
fi

# Start the main server process
exec "$@"