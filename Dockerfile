FROM moodlehq/moodle-php-apache:7.3
LABEL maintainer "Bryan Muñoz <swsbmm@gmail.com>"
LABEL maintainer "Juan Felipe Rodriguez Galindo <juferoga@gmail.com>"

ENV URL_MOODLE_DOWNLOAD="https://download.moodle.org/download.php/direct/stable311/moodle-latest-311.tgz"
 # Que hace ?
 # 12. Descargar moodle de la pagina oficial.
 # 13. Descomprime moodle
 # 14. Borra el comprimido descargado
 # 15. Mueve el archivo temporal a /var/www/html
RUN cd /tmp/ && echo "Se movio de carpeta"; sleep 1\
 && curl -o /tmp/moodle.tgz $URL_MOODLE_DOWNLOAD && echo "Se descargo moodle"; sleep 1 \
 && tar -xzvf /tmp/moodle.tgz && echo "Se descomprimio"; sleep 1\
 && rm *tgz && echo "Se borro"; sleep 1 \
 && mv /tmp/moodle/* /var/www/html && echo "Se mueve la carpeta"; sleep 1 \
 && rm -rf /tmp/moodle && echo "Borrado carpeta temporal"; sleep 1 \
 && chown -R www-data:www-data /var/www/html && echo "Directorio html - cambio de dueño - www-data"; sleep 1;

# && chown -R root /var/www/html && echo "Cambio de usurio a root"; sleep 1 \
# && chmod -R 0777 /var/www/html && echo "Cambio permisos"; sleep 1 \
# && find /var/www/html -type f -exec chmod 0644 {} \;  && echo "Cambio permisos"; sleep 1;

 ## Instlando cron
 ## activando cron
 ## Guardando cron
RUN apt-get clean && apt-get update && echo "Actualizando repositorios"; sleep 1\
 && apt-get install -y cron && echo "Se instala cron"; sleep 1\
 && echo "* * * * * root /usr/local/bin/php /var/www/html/admin/cli/cron.php 1>/var/log/moodle_good.log 2>/var/log/moodle_fail.log" >> /etc/crontab; echo "Se acabo"; sleep 1;

RUN rm -r /var/www/moodledata/cache/ && echo "Borrando carpeta de cache para evitar problemas"; sleep 1;


CMD /etc/init.d/cron start && /usr/sbin/apache2ctl -DFOREGROUND;
