# Migration from Firefly III Pre-built Image to Source Build

## Important Notice

This repository originally used the pre-built Firefly III Docker image (`fireflyiii/core:latest`). The recent changes attempt to switch to building from source, but this is a complex process that requires significant additional configuration.

## Recommended Approach

Rather than attempting to build Firefly III from source directly in this configuration (which is complex and error-prone), consider these alternatives:

### Option 1: Continue Using Official Images (Recommended)
Revert to using the official Firefly III images which are properly tested and maintained:

```yaml
version: '3.8'

services:
  # --- Service: Core Application ---
  app:
    image: fireflyiii/core:latest
    container_name: firefly_core
    restart: unless-stopped
    volumes:
      - firefly_upload:/var/www/html/storage/upload
    env_file: .env
    ports:
      - "${APP_PORT:-8080}:8080" # Exposed to Host for Reverse Proxy
    networks:
      - fin_net
    depends_on:
      db:
        condition: service_healthy
    # Fix for Currency Formatting (IDR requires proper locale)
    environment:
      - DKR_BUILD_LOCALE=id_ID.UTF-8
```

### Option 2: Build from Source Properly
If you really need to build from source, follow the official Firefly III build documentation at:
https://github.com/firefly-iii/firefly-iii

The proper build process involves:
- Setting up a proper build environment
- Handling asset compilation
- Managing dependencies correctly
- Following the official build scripts

### Option 3: Custom Laravel Application
If you want to create a completely custom financial management application in Laravel, this would be a significant development effort involving:
- Database schema design
- Authentication system
- Transaction management
- Budgeting features
- Reporting capabilities
- Security considerations
- And much more

This would be a months-long development project.

## Current State

The current configuration attempts to build from source but will likely not work without significant additional configuration. Use at your own risk.

## Recommendation

For stability and reliability, consider reverting to the official Firefly III images unless you have specific requirements that necessitate a custom build.