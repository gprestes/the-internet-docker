FROM ubuntu:latest

RUN apt-get -qq update
RUN apt-get -qqy install git curl
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -sSL https://get.rvm.io | bash -s stable
RUN /bin/bash -l -c "rvm requirements"
RUN /bin/bash -l -c "rvm install 2.2.2"
RUN /bin/bash -l -c "gem install bundler"

RUN git clone https://github.com/tourdedave/the-internet.git app
WORKDIR /app
RUN /bin/bash -l -c "bundle install --quiet"
EXPOSE 5000
# CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5000"]
CMD ["/bin/bash", "-l", "-c", "bundle exec rackup --host 0.0.0.0 -p 5000"]
