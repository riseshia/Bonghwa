FROM ruby:2.4.1
MAINTAINER shia <rise.shia@gmail.com>

RUN mkdir /app
WORKDIR /app

RUN apt-get update && \
    apt-get install -y nodejs \
                       mysql-client \
                       sqlite3 \
                       --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN bundle config build.nokogiri --use-system-libraries

ADD ./Gemfile /app/
ADD ./Gemfile.lock /app/
RUN \
  echo 'gem: --no-document' >> ~/.gemrc && \
  cp ~/.gemrc /etc/gemrc && \
  chmod uog+r /etc/gemrc && \
  rm -rf ~/.gem
