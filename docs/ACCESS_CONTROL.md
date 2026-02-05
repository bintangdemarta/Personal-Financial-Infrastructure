# Access Control Policy

## Goals

- Limit admin access to trusted operators.
- Protect sensitive financial data.
- Maintain an audit trail of changes.

## Roles

- **Admin**: Full configuration access, account creation, rule setup.
- **User**: Day-to-day transaction entry and reconciliation.

## Network Controls

- Restrict access by IP allowlist or VPN.
- Expose only HTTPS via Traefik; do not expose the DB port.

## Credentials

- Use strong, unique passwords for all accounts.
- Rotate credentials quarterly or after any incident.
- Do not store secrets in git; use `.env` and offsite secret storage.

## Access Reviews

- Review user list monthly.
- Remove inactive or untrusted accounts promptly.
