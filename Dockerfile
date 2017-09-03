# 本体
#
# VERSION               0.0.1

FROM gendosu/ubuntu-base:14.10

MAINTAINER Gen Takahashi "gendosu@gmail.com"

RUN groupadd -g 1000 ubuntu
RUN useradd -g ubuntu -k /etc/skel -m -u 1000 ubuntu
RUN usermod -G root -a ubuntu

RUN mkdir /products
RUN mkdir /entrypoint
RUN chown ubuntu:ubuntu /products

#ADD . /products
ADD entrypoint/entrypoint.sh /entrypoint
RUN chmod a+x /entrypoint/entrypoint.sh
ADD Gemfile /products
ADD Gemfile.lock /products
WORKDIR /products

RUN apt-get update \
&&  apt-get upgrade -y --force-yes \
&&  apt-get install -y --force-yes \
    libmysqlclient-dev \
    libxslt1-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    imagemagick \
    libmagick++-dev \
    libmagickcore-dev \
    libmagickwand-dev \
    libc6-dev \
    make gcc \
    subversion \
    autoconf \
    byacc \
    sudo \
    nodejs \
    npm \
&&  apt-get clean \
&&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

#RUN ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/Magick-config /usr/bin/Magick-config

#RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
#RUN apt-get install -y nodejs 

#&&  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
#&&  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
#&&  apt-get update \
#&&  apt-get install -y --force-yes \
#    yarn \
#&&  apt-get clean \
#&&  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

USER ubuntu

ENV HOME "/home/ubuntu"
ENV PATH "./node_modules/.bin:$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
ENV RBENV_ROOT "$HOME/.rbenv"

RUN git clone https://github.com/rbenv/rbenv.git $HOME/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git $HOME/.rbenv/plugins/ruby-build

RUN rbenv install 1.8.7-p375
RUN rbenv global 1.8.7-p375
RUN gem install bundler -v 1.3.6 --no-ri --no-rdoc
RUN rbenv rehash

RUN gem update --system 1.8.25

RUN bundle

#RUN /entrypoint/entrypoint.sh

ENTRYPOINT ["/entrypoint/entrypoint.sh"]
