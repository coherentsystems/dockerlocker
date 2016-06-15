FROM gliderlabs/alpine:3.3
MAINTAINER JB Smith <jb.smith@ixi.systems>

RUN \
    apk -U upgrade && \
    apk -U add ca-certificates && \
    apk -U add ncurses && \
    apk -U add bash && \
    update-ca-certificates

ENV REFRESHED_AT=2016-04-11 \
    LANG=en_US.UTF-8 \
    HOME=/app \
    # Set this so that CTRL+G works properly
    TERM=xterm

RUN \
    mkdir -p ${HOME} && \
    adduser -s /bin/sh -u 1001 -G root -h ${HOME} -S -D default && \
    chown -R 1001:0 ${HOME} && \
    echo 'http://dl-4.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
    echo 'http://dl-4.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

# Install Erlang
RUN \
    apk-install \
        erlang erlang-dev erlang-kernel erlang-hipe erlang-compiler \
        erlang-stdlib erlang-erts erlang-syntax-tools erlang-sasl \
        erlang-crypto erlang-public-key erlang-ssl erlang-tools \
        erlang-inets erlang-runtime-tools \
        erlang-erl-interface erlang-parsetools

ENV VERSION 0.0.1
ENV PORT 9999
EXPOSE $PORT
ARG APP_TARGZ

WORKDIR $HOME
COPY ${APP_TARGZ} ${HOME}


RUN tar -xvzf *.gz
RUN rm -rf *.gz

WORKDIR $HOME/releases/$VERSION
ADD startup.sh $HOME/releases/$VERSION
RUN chmod 755 $HOME/releases/$VERSION/startup.sh

ENTRYPOINT ["./startup.sh"]
CMD ["foreground"]

