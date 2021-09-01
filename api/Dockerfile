FROM ruby:2.7.4-alpine3.14

ENV TZ=Asia/Tokyo

RUN apk update && \
    apk add --no-cache \
        build-base \
        mysql-dev \
        tzdata \
        imagemagick

WORKDIR /app
COPY Gemfile Gemfile.lock /app/
RUN bundle install
COPY . .

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
CMD ["rails", "s", "-b", "0.0.0.0"]
