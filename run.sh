#!/bin/bash

# Precompile the assets
echo "Precompiling assets..."
bundle exec rails assets:precompile

# Check if precompilation was successful
if [ $? -eq 0 ]; then
  echo "Assets precompiled successfully."
  echo "Starting Rails server..."
  # Start the Rails server
  bundle exec rails server
else
  echo "Asset precompilation failed. Rails server not started."
fi
