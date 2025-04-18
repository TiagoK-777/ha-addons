ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache jq nginx

COPY nginx.conf /etc/nginx/nginx.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 21465

ENTRYPOINT [ "sh", "/start.sh" ]

