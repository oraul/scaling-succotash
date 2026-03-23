FROM ruby:4.0.2-alpine

RUN apk add --no-cache build-base sqlite-dev

WORKDIR /app

COPY Gemfile ./
RUN bundle install --without development test

COPY . .

RUN mkdir -p db

EXPOSE 3000

CMD ["bundle", "exec", "falcon", "host", "--bind", "http://0.0.0.0:3000"]
