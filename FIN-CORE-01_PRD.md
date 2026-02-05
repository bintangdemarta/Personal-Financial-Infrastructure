# Engineering Specification: Personal Financial Infrastructure (FIN-CORE-01)

| Document Metadata | Details |
| :--- | :--- |
| **Project Code** | `FIN-CORE-01` |
| **Version** | **1.3.1 (Final Config)** |
| **Owner** | Principal Architect (User) |
| **Date** | 2026-02-05 |
| **Status** | **APPROVED / READY TO DEPLOY** |
| **Stack** | Docker, Laravel (Firefly III), MariaDB, Alpine Linux |

---

## 1. Executive Summary

### 1.1 Objective
To architect and deploy a self-hosted, double-entry bookkeeping system that guarantees **Data Sovereignty** and **Financial Observability**. This system will serve as the "Single Source of Truth" for the user's personal finances, academic funding, and startup capital ("Project IO"), replacing deprecated manual tracking methods with a cloud-native, automated data pipeline.

### 1.2 Design Philosophy (First-Principles)
1.  **Immutability:** Financial data is an appended log. History must not be rewritten without an audit trail.
2.  **Isolation of Concerns:** Strict logical separation between Personal OpEx, Academic Funds, and Business Capital.
3.  **Automation over Toil:** Reduce human intervention through Cron jobs, API integrations, and recurring rules.

---

## 2. System Architecture

### 2.1 Component Diagram
The system utilizes a Micro-Service architecture encapsulated within a private Docker network.

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
2.2 Technology StackApplication Layer: Firefly III (Laravel Framework) - Stateless.Data Layer: MariaDB 11.x (InnoDB Engine) - ACID compliant.Orchestration: Docker Compose (v3.8+).Automation: Alpine Linux Sidecar (running crond).3. Infrastructure as Code (IaC)3.1 Docker Compose Specification (docker-compose.yml)Optimized for security (internal networking), locale (IDR currency), and reliability.YAMLversion: '3.8'

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

  # --- Service: Database ---
  db:
    image: mariadb:11
    container_name: firefly_db
    restart: unless-stopped
    # Critical flags for data integrity and encoding
    command: 
      - --transaction-isolation=READ-COMMITTED
      - --binlog-format=ROW
      - --character-set-server=utf8mb4
      - --collation-server=utf8mb4_unicode_ci
    environment:
      - MYSQL_RANDOM_ROOT_PASSWORD=yes
      - MYSQL_USER=${DB_USERNAME}
      - MYSQL_PASSWORD=${DB_PASSWORD}
      - MYSQL_DATABASE=${DB_DATABASE}
    volumes:
      - firefly_db_data:/var/lib/mysql
    networks:
      - fin_net # Isolated: No ports exposed to host
    healthcheck:
      test: ["CMD", "healthcheck.sh", "--connect", "--innodb_initialized"]
      interval: 10s
      timeout: 5s
      retries: 5

  # --- Service: Automation Sidecar ---
  cron:
    image: alpine:latest
    container_name: firefly_cron
    restart: unless-stopped
    # Robust Cron Command: waits for app to be ready, then triggers daily at 3 AM
    command: >
      sh -c "echo '0 3 * * * wget -qO- http://app:8080/api/v1/cron/${STATIC_CRON_TOKEN}' | crontab - && crond -f -L /dev/stdout"
    networks:
      - fin_net
    depends_on:
      - app

volumes:
  firefly_upload:
  firefly_db_data:

networks:
  fin_net:
    driver: bridge
3.2 Configuration Secrets (.env)Contains the approved credentials. Save this file in the same directory as docker-compose.yml.Bash# --- INSTANCE IDENTITY ---
# Critical: Must match your actual URL (IP or Domain) to prevent CORS errors.
APP_URL=[http://192.168.1.](http://192.168.1.)X:8080
APP_KEY=ChangeMeToA32CharacterRandomString!!
APP_ENV=production
APP_DEBUG=false

# --- LOCALIZATION ---
SITE_OWNER=me@example.com
TZ=Asia/Jakarta
DEFAULT_LANGUAGE=en_US
DEFAULT_LOCALE=id_ID

# --- DATABASE CONNECTION ---
DB_CONNECTION=mysql
DB_HOST=db
DB_PORT=3306
DB_DATABASE=firefly
DB_USERNAME=fin_admin
# SELECTED PASSWORD (OPTION 1)
DB_PASSWORD=9xL#m2$vP8qZ!wR5

# --- PROXY & SECURITY ---
# Required for Nginx/Traefik
TRUSTED_PROXIES=**
APP_FORCE_Root_URL=${APP_URL}

# --- AUTOMATION SECURITY ---
STATIC_CRON_TOKEN=ChangeThisToRandomTokenForCronJob
4. Data Governance & Accounting Logic4.1 Chart of Accounts (Asset Structure)The system requires a strict segregation of funds to support the user's multi-faceted role.Account GroupRoleDescriptionPersonal LiquidAssetMain checking account for daily OpEx (Food, Transport).Project IO (Startup)AssetStrictly Isolated. Seed capital for server costs, hardware (ESP32), and R&D.Academic FundAssetReserved funds for Thesis (Skripsi), tuition, and graduation fees.Short-Term ReserveAssetEmergency Fund (High Liquidity).LiabilitiesLiabilityCredit Cards, PayLater services.4.2 Automated Rules (The "Allocation Engine")Rule A (Income Routing): If Description contains "Project", route 20% to Tax_Reserve and 80% to Project_IO_Liquid.Rule B (Subscription Management): If Description contains "DigitalOcean/AWS", tag as #Infrastructure and #Project_IO.5. Operations & Recovery (Runbook)5.1 Pre-Flight Check (First Run)Docker volumes often have permission issues on first creation.Bash# Run immediately after first 'docker-compose up -d'
docker exec -it firefly_core chown -R www-data:www-data /var/www/html/storage/upload
5.2 Backup Strategy (3-2-1 Rule)Script: backup_db.shBash#!/bin/bash
# Description: Hot backup of MariaDB container
BACKUP_DIR="./backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M")
CONTAINER="firefly_db"
DB_USER="fin_admin"
DB_PASS="9xL#m2$vP8qZ!wR5" # Matches .env

mkdir -p $BACKUP_DIR

# Dump Database
docker exec $CONTAINER /usr/bin/mysqldump -u $DB_USER --password=$DB_PASS firefly | gzip > "$BACKUP_DIR/db_$TIMESTAMP.sql.gz"

# Retention Policy (Keep 30 Days)
find $BACKUP_DIR -name "db_*.sql.gz" -mtime +30 -delete

echo "[OK] Backup completed: db_$TIMESTAMP.sql.gz"
6. Implementation Checklist[ ] Infrastructure: Install Docker & Compose on the host.[ ] Configuration: Create .env file with the contents from Section 3.2.[ ] Deployment: Run docker-compose up -d.[ ] Permission Fix: Execute the chown command from Section 5.1.[ ] Verification: Access web UI (http://IP:8080), create the first Admin User.[ ] Initialization: Set up the "Asset Accounts" (Section 4.1).[ ] Backup Test: Run bash backup_db.sh manually to confirm it works.