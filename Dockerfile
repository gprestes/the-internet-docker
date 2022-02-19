FROM ruby:2.7.2

RUN git clone https://github.com/saucelabs/the-internet.git app
WORKDIR /app
RUN gem install bundler:2.3.7 && bundle install --quiet
EXPOSE 5000
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5000"]
