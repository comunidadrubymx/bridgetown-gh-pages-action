FROM alpine:3.15 as libstdc-donor
RUN apk add --no-cache --repository http://nl.alpinelinux.org/alpine/edge/main libstdc++

ENV LC_ALL C.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

FROM ruby:3.1.0-alpine3.15
COPY --from=libstdc-donor /usr/lib/libstdc++.so.6.0.29 /usr/lib/libstdc++.so.6.0.29
RUN rm /usr/lib/libstdc++.so.6 && ln -s /usr/lib/libstdc++.so.6.0.29 /usr/lib/libstdc++.so.6
RUN apk -UvX http://dl-4.alpinelinux.org/alpine/edge/main add nodejs

RUN apk --no-cache add build-base git; \
  apk add --repository http://dl-cdn.alpinelinux.org/alpine/edge/main/ --no-cache \
  npm \
  yarn

# This is our entrypoint to our custom scripts
# more about that in a sec
COPY entrypoint.sh /entrypoint.sh

# Use the entrypoint.sh file as the container entrypoint
# when Github executes our Docker container
ENTRYPOINT ["sh", "/entrypoint.sh"]
