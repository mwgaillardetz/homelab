# Architecture

The current host uses independent Compose projects. Docker Desktop provides the
engine, per-project bridge networks isolate most stacks, and Nginx Proxy Manager
is the ingress layer for browser-facing services.

```mermaid
flowchart TB
  users[LAN clients] --> npm[Nginx Proxy Manager]
  npm --> media[Media and reading]
  npm --> photos[Photos and documents]
  npm --> music[Music services]
  npm --> tools[Operations and utilities]

  media --> plex[Plex / Jellyfin / Tautulli]
  media --> library[Kavita]
  photos --> immich[Immich]
  photos --> paperless[Paperless-ngx]
  music --> navidrome[Navidrome]
  music --> scrobble[Koito / Maloja / Multi-Scrobbler]
  tools --> monitoring[Datadog / Dockhand]
  tools --> security[Fail2ban / Gluetun]

  engine[Docker Desktop] --> npm
  engine --> media
  engine --> photos
  engine --> music
  engine --> tools
```

This is a logical view generated from project and service names. Network-level
relationships will be added as stacks migrate into this repository.
