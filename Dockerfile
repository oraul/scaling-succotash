FROM ruby:4.0.2-alpine

RUN apk add --no-cache build-base sqlite-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

RUN mkdir -p db

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rake db:migrate && bundle exec falcon serve --bind http://0.0.0.0:3000"]
