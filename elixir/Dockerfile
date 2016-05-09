FROM gcr.io/coherent-api-service/erlang:1.0.0
MAINTAINER JB Smith <jb.smith@ixi.systems>

# Install Elixir
RUN \
    apk --no-cache --update add \
      git make g++ wget curl \
      elixir=1.2.5-r0 \
      nodejs=5.11.0-r0 && \
    npm install npm -g --no-progress && \
    rm -rf /var/cache/apk/*

# Add local node module binaries to PATH
ENV PATH ./node_modules/.bin:$PATH

# Install Hex+Rebar
RUN \
  mix local.hex --force && \
  mix local.rebar --force

WORKDIR ${HOME}

CMD ["/bin/sh"]