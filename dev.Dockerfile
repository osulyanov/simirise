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

WORKDIR /app

ADD Gemfile* ./
RUN gem install bundler
RUN gem update --system
RUN bundle install

COPY . .

EXPOSE 3000

ENTRYPOINT ["bundle", "exec", "puma", "-C", "config/puma.dev.rb"]
