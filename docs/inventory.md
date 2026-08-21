# Service inventory

Generated from Docker metadata on 2026-08-21 11:06:59 -04:00. This file excludes environment values, mounts, labels, logs, and secrets.

- Containers: 47
- Running: 44
- Projects: 26

| Project | Service | Image | State | Health | Published ports |
|---|---|---|---|---|---|
| atlas | atlas | keinstien/atlas:latest | running | - | 8886 -> 8884/tcp<br>8887 -> 8885/tcp |
| azerothcore-wotlk | ac-authserver | acore/ac-wotlk-authserver:master | running | - | 3724 -> 3724/tcp |
| azerothcore-wotlk | ac-client-data-init | acore/ac-wotlk-client-data:master | exited | - | - |
| azerothcore-wotlk | ac-database | mysql:8.4 | running | healthy | 3306 -> 3306/tcp |
| azerothcore-wotlk | ac-db-import | acore/ac-wotlk-db-import:master | exited | - | - |
| azerothcore-wotlk | ac-llm-chatter-bridge | python:3.11-slim | running | - | - |
| azerothcore-wotlk | ac-volfix | alpine:latest | exited | - | - |
| azerothcore-wotlk | ac-worldserver | acore/ac-wotlk-worldserver:master | running | - | 7178 -> 7878/tcp<br>8085 -> 8085/tcp |
| datadog | dd-agent | public.ecr.aws/datadog/agent:latest | running | healthy | 8617 -> 4317/tcp<br>8618 -> 4318/tcp<br>8625 -> 8125/udp<br>8626 -> 8126/tcp |
| datadog-gpu | dcgm-exporter | nvcr.io/nvidia/k8s/dcgm-exporter:3.1.7-3.1.4-ubuntu20.04 | running | - | 9400 -> 9400/tcp |
| dockhand | dockhand | fnsys/dockhand:latest | running | healthy | 2100 -> 3000/tcp |
| fail2ban | fail2ban | lscr.io/linuxserver/fail2ban:latest | running | - | - |
| flaresolverr | flaresolverr | ghcr.io/flaresolverr/flaresolverr:latest | running | - | 8191 -> 8191/tcp |
| frigate | frigate | ghcr.io/blakeblackshear/frigate:0.16.3-tensorrt | running | healthy | 5112 -> 5000/tcp<br>8554 -> 8554/tcp<br>8555 -> 8555/tcp<br>8555 -> 8555/udp<br>8971 -> 8971/tcp |
| frigate-notify | frigate-notify | ghcr.io/0x2142/frigate-notify:latest | running | - | - |
| gluetun | db-wpmg | mariadb:10.6.4-focal | running | - | - |
| gluetun | deemix | ghcr.io/bambanah/deemix:v4.3.3 | running | - | - |
| gluetun | dispatcharr2 | ghcr.io/dispatcharr/dispatcharr:latest | running | healthy | - |
| gluetun | firefox | jlesage/firefox:latest | running | - | - |
| gluetun | gluetun | qmcgaw/gluetun:latest | running | healthy | 5021 -> 5021/tcp<br>5030 -> 5030/tcp<br>5031 -> 5031/tcp<br>5032 -> 50300/tcp<br>5055 -> 5055/tcp<br>5800 -> 5800/tcp<br>6080 -> 80/tcp<br>6596 -> 6595/tcp<br>7576 -> 7575/tcp<br>8388 -> 8388/tcp<br>8388 -> 8388/udp<br>8888 -> 8888/tcp<br>9925 -> 9000/tcp |
| gluetun | gluetun2 | qmcgaw/gluetun:latest | running | healthy | 8389 -> 8388/tcp<br>8389 -> 8388/udp<br>8889 -> 8888/tcp<br>9192 -> 9191/tcp |
| gluetun | homarr2 | ghcr.io/homarr-labs/homarr:latest | running | - | - |
| gluetun | mealie | ghcr.io/mealie-recipes/mealie:v2.5.0 | running | healthy | - |
| gluetun | overseerr | lscr.io/linuxserver/overseerr:1.33.2 | running | - | - |
| gluetun | qbittorrent | lscr.io/linuxserver/qbittorrent:latest | running | - | - |
| gluetun | slskd | slskd/slskd:latest | running | healthy | - |
| gluetun | wordpress | wordpress:6.9.0-php8.2-apache | running | - | - |
| immich | database | ghcr.io/immich-app/postgres:14-vectorchord0.4.3-pgvectors0.2.0@sha256:bcf63357191b76a916ae5eb93464d65c07511da41e3bf7a8416db519b40b1c23 | running | healthy | - |
| immich | immich-machine-learning | ghcr.io/immich-app/immich-machine-learning:v2.4.1 | running | healthy | - |
| immich | immich-server | ghcr.io/immich-app/immich-server:v2.4.1 | running | healthy | 8783 -> 2283/tcp |
| immich | redis | docker.io/valkey/valkey:9@sha256:fb8d272e529ea567b9bf1302245796f21a2672b8368ca3fcb938ac334e613c8f | running | - | - |
| iptv-epg | iptv-epg | ghcr.io/iptv-org/epg:master | running | - | 7776 -> 3000/tcp |
| jellyfin | jellyfin | jellyfin/jellyfin:10.11.4 | running | healthy | 5096 -> 8096/tcp |
| kavita | kavita | jvmilazz0/kavita:latest | running | healthy | 5090 -> 5000/tcp |
| koito | koito | gabehf/koito:latest | running | - | 4110 -> 4110/tcp |
| maloja | maloja | krateng/maloja:latest | running | - | 42010 -> 42010/tcp |
| multiscrobbler | multi-scrobbler | foxxmd/multi-scrobbler:latest | running | - | 9078 -> 9078/tcp |
| musicgrabber | music-grabber | g33kphr33k/musicgrabber:latest | running | healthy | 38274 -> 8080/tcp |
| navidrome | navidrome | deluan/navidrome:latest | running | - | 4533 -> 4533/tcp |
| nginxproxy-docker | app | jc21/nginx-proxy-manager:latest | running | - | 443 -> 443/tcp<br>80 -> 80/tcp<br>81 -> 81/tcp |
| open-webui | open-webui | ghcr.io/open-webui/open-webui:main | running | healthy | 3050 -> 8080/tcp |
| paperless | broker | docker.io/library/redis:8 | running | - | - |
| paperless | webserver | ghcr.io/paperless-ngx/paperless-ngx:latest | running | healthy | 7700 -> 8000/tcp |
| plex | plex | plexinc/pms-docker:latest | running | healthy | 1900 -> 1900/udp<br>3005 -> 3005/tcp<br>32400 -> 32400/tcp<br>32410 -> 32410/udp<br>32412 -> 32412/udp<br>32413 -> 32413/udp<br>32414 -> 32414/udp<br>32469 -> 32469/tcp<br>8324 -> 8324/tcp |
| qbitui | qbitwebui | ghcr.io/maciejonos/qbitwebui:latest | running | - | 3250 -> 3000/tcp |
| tautuli | tautulli | ghcr.io/tautulli/tautulli | running | healthy | 8181 -> 8181/tcp |
| trillium | trilium | triliumnext/notes:latest | running | healthy | 3080 -> 8080/tcp |
