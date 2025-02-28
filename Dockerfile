FROM vectorim/element-web AS extract

# ======================================= #

FROM ghcr.io/polarix-containers/nginx:unprivileged-mainline-slim

LABEL maintainer="Thien Tran contact@tommytran.io"

ENV LD_PRELOAD=""
USER root

# Install jq and moreutils for sponge, both used by our entrypoints
RUN apk add jq moreutils

COPY --from=extract /app /app

# Override default nginx config. Templates in `/etc/nginx/templates` are passed
# through `envsubst` by the nginx docker image entry point.
COPY /etc/nginx/templates/* /etc/nginx/templates/
COPY --from=extract /docker-entrypoint.d/18-load-element-modules.sh /docker-entrypoint.d/

RUN --network=none \
    rm -rf /usr/share/nginx/html \
    && ln -s /app /usr/share/nginx/html

# HTTP listen port
ENV ELEMENT_WEB_PORT=8080

ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"
USER $UID

HEALTHCHECK --start-period=5s --interval=15s --timeout=5s \
    CMD curl -fSs http://localhost:$ELEMENT_WEB_PORT/config.json || exit 1