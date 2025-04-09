ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache jq

COPY start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT [ "sh", "/start.sh" ]

