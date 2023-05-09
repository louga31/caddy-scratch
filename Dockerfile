FROM caddy:builder-alpine AS builder

ARG PLUGINS=
RUN for plugin in $(echo $PLUGINS | tr "," " "); do withFlags="$withFlags --with $plugin"; done && \
    xcaddy build latest ${withFlags}

FROM caddy:alpine 

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
