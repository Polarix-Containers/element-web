FROM vectorim/element-web AS extract

FROM ghcr.io/polarix-containers/nginx:unprivileged-mainline-slim

LABEL maintainer="Thien Tran contact@tommytran.io"

ENV LD_PRELOAD=""
USER root

COPY --from=extract /app /app
COPY /etc/nginx/conf.d/default.conf /etc/nginx/conf.d

RUN --network=none \
    rm -rf /usr/share/nginx/html \
    && ln -s /app /usr/share/nginx/html

# HTTP listen port
ENV ELEMENT_WEB_PORT=8080

ENV LD_PRELOAD="/usr/local/lib/libhardened_malloc.so"
USER $UID
