FROM ruby:2.6.5

RUN git clone https://github.com/saucelabs/the-internet.git app
WORKDIR /app
RUN gem install bundler:1.17.3
RUN bundle install --quiet
EXPOSE 5000
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5000"]
