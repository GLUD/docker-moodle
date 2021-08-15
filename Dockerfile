FROM moodlehq/moodle-php-apache:8.0
LABEL maintainer "Bryan Muñoz <swsbmm@gmail.com>"
LABEL maintainer "Juan Felipe Rodriguez Galindo <juferoga@gmail.com>"

ENV URL_MOODLE_DOWNLOAD ""
 # Que hace ?
 # 12. Descargar moodle de la pagina oficial.
 # 13. Descomprime moodle
 # 14. Borra el comprimido descargado
 # 15. Mueve el archivo temporal a /var/www/html
RUN cd /tmp/ && echo "se movio de carpeta"; sleep 1\
 && curl -o /tmp/moodle.tgz $URL_MOODLE_DOWNLOAD && echo "se descargo moodle"; sleep 1 \
 && tar -xzvf /tmp/moodle.tgz && echo "se descomprimio"; sleep 1\
 && rm *tgz && echo "se borro"; sleep 1 \
 && mv /tmp/moodle/* /var/www/html && echo "Se mueve la carpeta"; sleep 1 \
 && rm -rf /tmp/moodle && echo "Borrado carpeta temporal"; sleep 1 \
 && chown -R root /var/www/html && echo "cambio de usurio a root"; sleep 1 \
 && chmod -R 0755 /var/www/html && echo "cambio permisos"; sleep 1 \
 && find /var/www/html -type f -exec chmod 0644 {} \;  && echo "cambio permisos"; sleep 1;

 ## Instlando cron
 ## activando cron
 ## Guardando cron
RUN apt update && echo "Se actualizan los repositorios"; sleep 1\
 && apt install -y cron && echo "Se instala cron"; sleep 1\
 && /etc/init.d/cron start && echo "Se activa servicio de cron"; sleep 1\
 && echo "*/1 * * * * root /usr/local/bin/php /var/www/html/admin/cli/cron.php 1>/var/log/moodle_good.log 2>/var/log/moodle_fail.log" >> /etc/crontab; echo "Se acabo"; sleep 1;
