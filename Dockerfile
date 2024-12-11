FROM ghcr.io/linuxserver/baseimage-alpine-nginx:3.20

# set version label
ARG BUILD_DATE
ARG VERSION
ARG RS_RELEASE
LABEL build_version="rpa21 version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="rpa21"

RUN \
    echo "**** install packages ****" && \
    apt-get update && apt-get install -y \
        vim \
        imagemagick \
        apache2 \
        subversion \
        ghostscript \
        antiword \
        poppler-utils \
        libimage-exiftool-perl \
        inkscape \
        cron \
        postfix \
        wget \
        php \
        php83-mysqli \
        php-83curl \
        php83-dom \
        php83-gd \
        php83-intl \
        php-mbstring \
        php83-xml \
        php83-zip \
        php83-ldap \
        php-imap \
        php83-json \
        php83-apcu \
        php83-cli \
        libapache2-mod-php \
        ffmpeg \
        libopencv-dev \
        python3-opencv \
        python3 \
        python3-pip \
     && rm -rf /var/lib/apt/lists/*
RUN sed -i -e "s/upload_max_filesize\s*=\s*2M/upload_max_filesize = 10G/g" /etc/php/8.3/apache2/php.ini                                                      
RUN sed -i -e "s/post_max_size\s*=\s*8M/post_max_size = 10G/g" /etc/php/8.3/apache2/php.ini                                                                  
RUN sed -i -e "s/max_execution_time\s*=\s*30/max_execution_time = 10000/g" /etc/php/8.3/apache2/php.ini                                                      
RUN sed -i -e "s/memory_limit\s*=\s*128M/memory_limit = 4G/g" /etc/php/8.3/apache2/php.ini

RUN printf '<Directory /var/www/>\n\
\tOptions FollowSymLinks\n\
</Directory>\n'\
>> /etc/apache2/sites-enabled/000-default.conf

ADD cronjob /etc/cron.daily/resourcespace

WORKDIR /var/www/html
RUN rm index.html

RUN svn co -q https://svn.resourcespace.com/svn/rs/releases/10.4 .
RUN mkdir filestore
RUN chmod 777 filestore
RUN chmod -R 777 include/
CMD apachectl -D FOREGROUND
