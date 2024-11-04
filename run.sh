#!/bin/bash

# Precompile the assets
echo "Precompiling assets..."
rails assets:precompile

# Check if precompilation was successful
if [ $? -eq 0 ]; then
  echo "Assets precompiled successfully."
  echo "Starting Rails server..."
  # Start the Rails server
  rails s
else
  echo "Asset precompilation failed. Rails server not started."
fi
