FROM gliderlabs/alpine:3.3
MAINTAINER JB Smith <jb.smith@ixi.systems>

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN apk update
RUN apk add curl bash "postgresql@edge>9.5"

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN curl -o /usr/local/bin/gosu -sSL "https://github.com/tianon/gosu/releases/download/1.7/gosu-amd64"
RUN chmod +x /usr/local/bin/gosu

ENV LANG en_US.utf8
ENV PG_MAJOR 9.5
ENV PG_VERSION 9.5.2-1.pgdg80+1
ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH

# explicitly set user/group IDs
RUN mkdir /docker-entrypoint-initdb.d
RUN mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql

COPY docker-entrypoint.sh /
RUN chmod 755 /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["postgres"]