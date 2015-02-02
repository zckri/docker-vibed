FROM ubuntu:14.10
MAINTAINER zckri <zckri@rarefields.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -y update
RUN apt-get -y install wget

# add dlang repository
RUN wget http://master.dl.sourceforge.net/project/d-apt/files/d-apt.list -O /etc/apt/sources.list.d/d-apt.list
RUN apt-get -y update 
RUN apt-get -y --allow-unauthenticated install --reinstall d-apt-keyring 
RUN apt-get -y update

# install dmd / dub / vibe.d dependencies
RUN apt-get -y install dub libcurl4-gnutls-dev libevent-dev libssl-dev

# install sample project
RUN mkdir /var/www
WORKDIR /var/www
RUN dub init vibesample vibe.d
RUN rm -rf /var/www/vibesample/source/app.d
ADD app.d /var/www/vibesample/source/app.d
WORKDIR /var/www/vibesample
RUN dub build
# prepare project for run - set permissions etc.
RUN chown -R www-data:www-data /var/www
EXPOSE 8080 
USER www-data
# compile and run
VOLUME /var/www/vibesample
CMD ["./vibesample"]
