#!/bin/bash

# Enhanced build script for Firefly III

set -e  # Exit on any error

echo "Starting enhanced build process for Firefly III..."

# Check if Docker is available
if ! [ -x "$(command -v docker)" ]; then
  echo "Error: Docker is not installed or not in PATH" >&2
  exit 1
fi

# Check if docker-compose is available
if ! [ -x "$(command -v docker-compose)" ]; then
  echo "Warning: docker-compose is not installed or not in PATH"
  echo "Using 'docker compose' instead..."
fi

# Build the application
echo "Building the application..."
if command -v docker-compose &> /dev/null; then
    docker-compose build
else
    docker compose build
fi

echo "Build completed successfully!"

echo ""
echo "To start the application, run:"
echo "  docker-compose up -d"
echo ""
echo "To view logs:"
echo "  docker-compose logs -f"
echo ""

# Optionally run tests if they exist
if [ -f "phpunit.xml" ] || [ -f "phpunit.xml.dist" ]; then
    echo "Running tests..."
    if command -v docker-compose &> /dev/null; then
        docker-compose run --rm app vendor/bin/phpunit
    else
        docker compose run --rm app vendor/bin/phpunit
    fi
fi