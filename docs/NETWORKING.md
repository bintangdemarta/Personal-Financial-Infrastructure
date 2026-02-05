# Networking Guide

## Ports

- 80/443: Traefik (HTTP/HTTPS)
- 8080: Firefly III internal app port (do not expose in prod)
- 3306: MariaDB (internal only)

## DNS

- Point your domain A/AAAA record to the host IP.

## Reverse Proxy

- Use Traefik or Nginx with HTTPS enabled.
- Ensure `APP_URL` matches the public URL.
