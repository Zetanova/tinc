FROM alpine:3.12

ENV VERSION=1.0.36 \
    LIBRESWAN_VERSION=3.32-r0 \
    TINC_VERSION=1.0.36-r0

#RUN sed -e 's;^#http\(.*\)/v3.10/community;http\1/v3.10/community;g' \
#     -i /etc/apk/repositories

RUN apk add --no-cache \ 
    libreswan=${LIBRESWAN_VERSION} \
    tinc=${TINC_VERSION}

EXPOSE 655/tcp 655/udp

VOLUME /etc/tinc

ENTRYPOINT ["tincd", "-D"]