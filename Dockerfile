FROM postgres:15

ENV PG_CRON_VERSION "1.5.2"
ENV PG_HTTP_VERSION "1.5.0"

RUN apt-get update && apt-get install -y --no-install-recommends \
  postgresql-server-dev-all postgresql-contrib \
  libcurl4-openssl-dev \
  wget jq cmake build-essential ca-certificates

RUN wget https://github.com/citusdata/pg_cron/archive/v$PG_CRON_VERSION.tar.gz && \
  tar xzvf v$PG_CRON_VERSION.tar.gz && \
  cd pg_cron-$PG_CRON_VERSION && \
  make && \
  make install && \
  rm -rf pg_cron-$PG_CRON_VERSION && \
  rm -rf v$PG_CRON_VERSION.tar.gz

RUN wget https://github.com/pramsey/pgsql-http/archive/refs/tags/v${PG_HTTP_VERSION}.tar.gz && \
  tar xzvf v$PG_HTTP_VERSION.tar.gz && \
  cd pgsql-http-$PG_HTTP_VERSION && \
  make && \
  make install && \
  rm -rf pgsql-http-$PG_HTTP_VERSION && \
  rm -rf v$PG_HTTP_VERSION.tar.gz

