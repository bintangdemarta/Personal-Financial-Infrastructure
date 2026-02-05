# Architecture

## Overview

```mermaid
graph TD
    subgraph "Host Node (Proxmox/Linux)"
        User[User / Mobile Client] -->|HTTPS/443| RevProxy[Reverse Proxy / Traefik]
        
        subgraph "Docker Internal Network (fin_net)"
            RevProxy -->|:8080| App[Firefly III Core]
            
            App -->|SQL Protocol| DB[(MariaDB 11)]
            Cron[Cron Sidecar] -->|REST API Trigger| App
        end
        
        subgraph "Persistence Layer (Volumes)"
            DB --> VolDB[Volume: db_data]
            App --> VolUp[Volume: upload_data]
        end
        
        BackupAgent[Backup Script] -.->|mysqldump| DB
    end
```

## Components

- **Firefly III Core**: Stateless Laravel app providing the UI/API.
- **MariaDB 11**: ACID-compliant database using InnoDB.
- **Cron Sidecar**: Triggers Firefly III cron endpoint for scheduled jobs.
- **Traefik**: Optional reverse proxy for HTTPS and routing.
- **Volumes**: Persistent storage for DB and uploads.
