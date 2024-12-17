# Element Web

![Build, scan & push](https://github.com/Polarix-Containers/element-web/actions/workflows/build.yml/badge.svg)

### Features & usage
- Rebases [official image]([https://github.com/acmesh-official/acme.sh/wiki/Run-acme.sh-in-docker](https://github.com/element-hq/element-web)) to the latest [polarix-containers/nginx:unprivileged-mainline-slim image](https://github.com/Polarix-Containers/nginx), to be used as a drop-in replacement.
- Unprivileged image: you should check your volumes' permissions (eg /data), default UID/GID is 101.
- Default port changed from `80` to `8080`.

### Sample Docker Compose config

```
  element:
    image: ghcr.io/polarix-containers/element-web:latest
    container_name: element
    restart: unless-stopped
    volumes:
      - ./element/config.json:/app/config.json:ro,Z
    user: "101:101"
    read_only: true
    tmpfs:
      - /var/cache/nginx:size=50M,mode=0770,noexec,nosuid,nodev
    security_opt:
      - no-new-privileges:true
    cap_drop:
      - ALL
```

### Licensing
- Licensed under AGPL 3 to comply with licensing by Element.
- Any image built by Polarix Containers is provided under the combination of license terms resulting from the use of individual packages.
