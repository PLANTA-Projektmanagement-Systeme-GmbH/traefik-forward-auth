FROM golang:1.13-alpine AS builder

# Setup
RUN mkdir -p /go/src/github.com/thomseddon/traefik-forward-auth
WORKDIR /go/src/github.com/thomseddon/traefik-forward-auth

# Add libraries
RUN apk add --no-cache git

# Copy & build
ADD ./forward-auth/ /go/src/github.com/thomseddon/traefik-forward-auth/
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 GO111MODULE=on go build -a -installsuffix nocgo -o /traefik-forward-auth github.com/thomseddon/traefik-forward-auth/cmd

# Get Traefik Binary
RUN set -x && \
	wget "https://github.com/traefik/traefik/releases/download/v2.0.0/traefik_v2.0.0_linux_386.tar.gz" -O "/tmp/traefik_v2.0.0_linux_386.tar.gz" && \
	tar -xvf "/tmp/traefik_v2.0.0_linux_386.tar.gz" -C /tmp/ traefik

# Add entrypoint script
COPY docker-entrypoint.sh /
RUN chmod 0750 /docker-entrypoint.sh

# Copy into scratch container
FROM alpine:3.13

ENV WORKDIR=/oidc

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY --from=builder /traefik-forward-auth ${WORKDIR}/
COPY --from=builder /tmp/traefik ${WORKDIR}/
COPY --from=builder /docker-entrypoint.sh /

ENV LOG_LEVEL=info
ENV DEFAULT_PROVIDER=oidc
ENV URL_PATH=/PlantaServerAdapter/_oauth
ENV XDG_CONFIG_HOME=/etc/traefik

WORKDIR ${WORKDIR}

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["traefik"]