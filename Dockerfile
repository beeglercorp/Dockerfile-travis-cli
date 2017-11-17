ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}


RUN apk update
RUN apk add --no-cache --virtual .build-dependencies \
	gcc \
	libc-dev \
	libffi-dev \
	make \
	ruby-dev
RUN apk add --no-cache ruby
RUN gem install travis -v 1.8.8 --no-rdoc --no-ri
RUN apk del .build-dependencies


ENTRYPOINT [ "travis" ]
