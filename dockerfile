FROM php:7.2-apache

RUN apt-get update

RUN apt-get install -y git

RUN apt-get install -y zip

#just because.
RUN apt-get install -y nano

RUN docker-php-ext-install pdo_mysql

#install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin/ --filename=composer

#set our application folder as an environment variable
ENV APP_HOME /var/www/html

#change uid and gid of apache to docker user uid/gid
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

#copy source files
COPY . $APP_HOME

# install all PHP dependencies
RUN composer install --no-interaction

#change ownership of our applications
RUN chown -R www-data:www-data $APP_HOME

#change document root to the public folder
RUN sed -i "s+DocumentRoot /var/www/html+DocumentRoot /var/www/html/public+" /etc/apache2/sites-available/000-default.conf

#enable mod_rewrite on apache2
RUN a2enmod rewrite

EXPOSE 80