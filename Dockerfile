FROM php:8.1-cli

COPY --from=composer:2.3.4 /usr/bin/composer /usr/local/bin/composer

RUN apt update && apt install -y \
    nodejs \
    npm

RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN npm install nodemon -g

COPY . /usr/src/lumen

WORKDIR /usr/src/lumen

RUN composer install --no-scripts
RUN composer dumpautoload --optimize

CMD bash -c "php -r \"file_exists('.env') || copy('.env.example', '.env');\" && nodemon --watch /usr/src/lumen --ext php --exec php -S 0.0.0.0:8000 -t ./public"
