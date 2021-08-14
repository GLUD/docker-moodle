FROM moodlehq/moodle-php-apache:8.0
LABEL maintainer "Bryan Muñoz <swsbmm@gmail.com>"
LABEL maintainer "Juan Felipe Rodriguez Galindo <juferoga@gmail.com>"


ENV VERSION 310
ENV URL_MOODLE ""
ENV CRON_MOODLE "*/1 * * * * /usr/local/bin/php /var/www/html/admin/cli/cron.php 1>/var/log/moodle1.log 2>/var/log/moodle.log"
# Pere que me dejaron un taller de frances XD, OK me voy a bañar 
# breve si algo sigamos en la tarde-noche XD# jaja buen, si porque depronto salgo
# entonces nos pillamos mas tarde 
# El crontab -u root no es igual a crontab -u www-data
RUN apt update \
 && apt install -y cron \
 && touch /var/log/moodle1.log /var/log/moodle.log \
 && echo $CRON_MOODLE_FAILS | crontab \ 
 ## activando cron
 && /etc/init.d/cron start \
RUN curl $URL_MOODLE \
| tar -xzC /tmp  \
 && mv /tmp/moodle/* /var/www/html \
 && rm -rf /tmp/moodle  \
 && chown -R root /var/www/html \
 && chmod -R 0755 /var/www/html \
 && find /var/www/html -type f -exec chmod 0644 {} \; \


RUN mkdir /var/moodledata \
 && echo "placeholder" > /var/moodledata/placeholder \
 #&& chown -R www-data:www-data /var/moodledata \
 && chown -R nginx: /var/moodledata \
 && chmod 0777 /var/moodledata \
 && read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat

VOLUME ["/var/moodledata"]

WORKDIR /app
COPY moodle_config.php /app/config.php
COPY php.ini /opt/docker/etc/php/php.ini
COPY nginx_10-php.conf /opt/docker/etc/nginx/vhost.common.d/10-php.conf
