FROM caddy:builder-alpine AS builder

ARG PLUGINS=
RUN for plugin in $(echo $PLUGINS | tr "," " "); do withFlags="$withFlags --with $plugin"; done && \
    xcaddy build latest ${withFlags}

FROM caddy:alpine 

ENV HOME=/caddydir \
    CADDYPATH=/caddydir/data \
    TZ=Europe/Paris
COPY --chown=1000 /caddydir /caddydir
VOLUME ["/caddydir"]
ENTRYPOINT ["/caddy"]
USER 1000
# see https://caddyserver.com/docs/cli
CMD ["run","--config","/caddydir/Caddyfile"]
COPY --chown=1000 Caddyfile /caddydir/Caddyfile
COPY --from=builder --chown=1000 /usr/bin/caddy /usr/bin/caddy
