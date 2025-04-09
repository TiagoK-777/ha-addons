# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

# Override original entrypoint
ENTRYPOINT ["/opt/bin/entry_point.sh"]
