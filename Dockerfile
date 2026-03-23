FROM ruby:3.4-alpine

RUN apk add --no-cache build-base sqlite-dev

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle config set --local jobs 1 && \
    bundle config set --local without development:test && \
    bundle install

COPY . .

RUN mkdir -p db

EXPOSE 3000

CMD ["sh", "-c", "bundle exec rake db:migrate && bundle exec falcon serve --bind http://0.0.0.0:3000"]
