ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache \
    jq \
    curl

HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -s http://localhost:21465/healthz | jq -e '.message == "OK"' || exit 1

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "sh", "/start.sh" ]
