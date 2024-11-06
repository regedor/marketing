#!/bin/bash

# Precompile the assets
echo "Precompiling assets..."
bundle exec rails assets:clobber --trace
bundle exec rails assets:precompile --trace

# Check if precompilation was successful
if [ $? -eq 0 ]; then
  echo "Assets precompiled successfully."
  echo "Starting Rails server..."
  
  bundle exec rails server
else
  echo "Asset precompilation failed. Rails server not started."
fi
