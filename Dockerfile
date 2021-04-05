FROM webdevops/php-nginx:7.4-alpine
LABEL maintainer "Sebastian Tabares Amaya <sytabaresa@gmail.com>"
LABEL maintainer "Juan Felipe Rodriguez Galindo <juferoga@gmail.com>"

ENV VERSION 310

RUN apk -U --no-progress add \
    acl mariadb-client postgresql-client php7.2-pgsql php7.2-opcache php7.2-pdo_pgsql

RUN curl https://download.moodle.org/download.php/direct/stable310/moodle-latest-310.tgz \
 | tar -xzC /tmp  \
 && mv /tmp/moodle/* /app \
 && rm -rf /tmp/moodle  \
 && chown -R root /app \
 && chmod -R 0755 /app \
 && find /app -type f -exec chmod 0644 {} \; \
 && chown -R nginx: /app


RUN mkdir /var/moodledata \
 && echo "placeholder" > /var/moodledata/placeholder \
 #&& chown -R www-data:www-data /var/moodledata \
 && chown -R nginx: /var/moodledata \
 && chmod 0777 /var/moodledata \
 && read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat

VOLUME ["/var/moodledata"]

WORKDIR /app
#COPY moodle_config.php /app/config.php
COPY php.ini /opt/docker/etc/php/php.ini
COPY nginx_10-php.conf /opt/docker/etc/nginx/vhost.common.d/10-php.conf
