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

## Data Flow (Narrative)

1. User accesses Firefly III through Traefik over HTTPS.
2. Firefly III reads and writes transaction data in MariaDB.
3. Cron sidecar triggers scheduled tasks via the Firefly III API.
4. Backups are taken via `mysqldump` and stored locally, then copied offsite.
