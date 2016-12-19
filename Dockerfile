FROM ubuntu:latest

MAINTAINER Guilherme Heuser Prestes <guilherme.prestes@gmail.com>

RUN apt-get -qq update && apt-get -qqy install \
    git  \
    make \
    wget
# RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
# RUN \curl -sSL https://get.rvm.io | bash -s stable
# RUN /bin/bash -l -c "rvm install 2.2.2"
RUN wget -O ruby-install-0.6.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.6.0.tar.gz
RUN tar -xzvf ruby-install-0.6.0.tar.gz
RUN cd ruby-install-0.6.0 && make install && cd ..
RUN ruby-install --system ruby 2.2.2
RUN rm -rf /var/lib/apt/lists/* && rm -rf ruby-install*
RUN gem install bundler

RUN git clone https://github.com/tourdedave/the-internet.git app
WORKDIR /app
RUN bundle install --quiet
EXPOSE 5000
CMD ["bundle", "exec", "rackup", "--host", "0.0.0.0", "-p", "5000"]
