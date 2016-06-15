FROM gliderlabs/alpine:3.3
MAINTAINER JB Smith <jb.smith@ixi.systems>

ENV REFRESHED_AT=2016-04-09 \
    LANG=en_US.UTF-8 \
    HOME=/opt/app/ \
    # Set this so that CTRL+G works properly
    TERM=xterm

RUN \
    apk -U upgrade && \
    apk -U add ca-certificates && \
    apk -U add ncurses && \
    apk -U add bash && \
    update-ca-certificates

RUN \
    mkdir -p ${HOME} && \
    adduser -s /bin/sh -u 1001 -G root -h ${HOME} -S -D default && \
    chown -R 1001:0 ${HOME} && \
    echo 'http://dl-4.alpinelinux.org/alpine/edge/main' >> /etc/apk/repositories && \
    echo 'http://dl-4.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

# Install Erlang
RUN \
    apk-install -U \
        erlang erlang-dev erlang-kernel erlang-hipe erlang-compiler \
        erlang-stdlib erlang-erts erlang-syntax-tools erlang-sasl \
        erlang-crypto erlang-public-key erlang-ssl erlang-tools \
        erlang-inets erlang-xmerl erlang-runtime-tools \
        erlang-erl-interface erlang-parsetools erlang-asn1

WORKDIR ${HOME}

CMD ["/bin/sh"]