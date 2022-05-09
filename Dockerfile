FROM ruby:2.6.5-alpine

ARG RAILS_VERSION
ARG BLACKLIGHT_VERSION

RUN apk add --update --no-cache \
  bash \
  build-base \
  gcompat \
  git \
  libxml2-dev \
  libxslt-dev \
  nodejs \
  sqlite-dev \
  tzdata \
  yarn

RUN mkdir /app
RUN mkdir /gem

RUN adduser -D blacklight
RUN chown -R blacklight /app /gem

USER blacklight

RUN gem install bundler && \
  bundle config build.nokogiri --use-system-libraries && \
  gem install rails -v $RAILS_VERSION

COPY --chown=blacklight . /gem

RUN rails new /app
WORKDIR /app
RUN echo "gem 'blacklight', '$BLACKLIGHT_VERSION'" >> Gemfile
RUN echo "gem 'blacklight-citeproc', path: '/gem'" >> Gemfile
RUN bundle install && \
    bundle exec rails generate blacklight:install --devise && \
    rails generate blacklight:citeproc:install && \
    rails webpacker:install

COPY --chown=blacklight ./bin/entrypoint.sh bin/entrypoint.sh

CMD ["bin/entrypoint.sh"]
