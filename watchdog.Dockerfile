FROM alpine:latest

# Install minimal required tools
RUN apk add --no-cache bash curl docker-cli

# Add the watchdog-entrypoint.sh script
COPY watchdog-entrypoint.sh /usr/local/bin/watchdog-entrypoint.sh
RUN chmod +x /usr/local/bin/watchdog-entrypoint.sh

ENTRYPOINT ["/usr/local/bin/watchdog-entrypoint.sh"]