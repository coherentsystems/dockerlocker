FROM gcr.io/coherent-api-service/elixir:1.0.0
MAINTAINER JB Smith <jb.smith@ixi.systems>

RUN \
  apk --update add postgresql-client && rm -rf /var/cache/apk/*

# Install Phoenix
RUN \
  mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez --force

ADD startup /opt/app/startup.sh
RUN chmod +x /opt/app/startup.sh

WORKDIR ${HOME}

CMD ["/opt/app/startup.sh"]