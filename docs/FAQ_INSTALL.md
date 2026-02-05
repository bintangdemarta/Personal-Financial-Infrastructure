# Install FAQ

## Do I need a domain?

No. You can run with an IP (e.g., `http://IP:8080`). A domain is recommended for HTTPS.

## Can I run without Traefik?

Yes. Use the base `docker-compose.yml` and access the app via port 8080.

## What if the web UI shows CORS errors?

Ensure `APP_URL` matches the exact URL you are using to access the app.

## How do I reset the admin password?

Use Firefly III's built-in password reset flow from the login screen.
