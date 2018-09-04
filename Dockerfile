FROM docker:18-dind

MAINTAINER Kyle Squizzato: 'kyle.squizzato@docker.com'

WORKDIR /

COPY ./populate-dtr.sh /

ENTRYPOINT ["/bin/sh", "/populate-dtr.sh"]
