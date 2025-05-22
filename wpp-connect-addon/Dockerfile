ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    jq \
    netcat-openbsd

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD sh -c 'nc -zw5 localhost ${SERVER_PORT:-21465} || exit 1'

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "sh", "/start.sh" ]

