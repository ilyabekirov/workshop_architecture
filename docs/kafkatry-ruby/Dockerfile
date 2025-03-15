FROM ruby:3.1.3-alpine3.17 AS builder

RUN mkdir -p /var/cache/apk && ln -s /var/cache/apk /etc/apk/cache

RUN --mount=type=cache,uid=1000,target=/var/cache/apk \
    apk update && apk add make gcc postgresql-dev musl-dev bash g++ jq nodejs

FROM builder AS gems

RUN gem install bundler:2.4.3 rubygems-bundler
RUN gem regenerate_binstubs

COPY Gemfile Gemfile.lock ./

RUN bundle config set app_config .bundle
RUN bundle config set path /.cache/bundle
RUN --mount=type=cache,uid=1000,target=/.cache/bundle \
    bundle install --jobs $(nproc) && \
    mkdir -p vendor && \
    cp -ar .cache/bundle vendor/bundle
RUN bundle config set path vendor/bundle

FROM builder

WORKDIR /app
COPY . /app

COPY --from=gems /usr/local/bundle/ /usr/local/bundle/
COPY --from=gems /vendor/bundle /app/vendor/bundle
