FROM ruby:2.7.4-alpine3.14

ENV TZ=Asia/Tokyo

RUN apk update && \
    apk add --no-cache \
        build-base \
        mysql-dev \
        tzdata

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . .
