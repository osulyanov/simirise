FROM ruby:2.5.4-alpine

RUN sed -i -e 's/dl-cdn/dl-4/' /etc/apk/repositories && \
    apk add --update \
    vim \
    git \
    tzdata \
    nodejs \
    build-base \
    postgresql-dev \
    ncurses \
    imagemagick \
    && rm -rf /var/cache/apk/*

RUN cp /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    echo "Europe/Moscow" > /etc/timezone

ENV RAILS_ROOT /app
WORKDIR $RAILS_ROOT

ENV RAILS_ENV production
ENV RAILS_SERVE_STATIC_FILES true

RUN echo "$MASTER_KEY" > config/master.key

ADD Gemfile* ./
RUN gem install bundler
RUN gem update --system
RUN bundle install --jobs 20 --retry 5 --without development test

COPY . .
RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.prod.rb"]
