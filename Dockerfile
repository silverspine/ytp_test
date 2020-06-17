FROM ruby:2.6.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs nodejs postgresql-client

RUN mkdir /ytp_test
WORKDIR /ytp_test

ADD Gemfile /ytp_test/Gemfile
ADD Gemfile.lock /ytp_test/Gemfile.lock

RUN bundle install

ADD . /ytp_test