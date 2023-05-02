# ベースイメージの選択
FROM php:8.1-apache

# システム依存関係のインストール
RUN apt-get update && apt-get install -y \
  git \
  curl \
  libpng-dev \
  libonig-dev \
  libxml2-dev \
  zip \
  unzip

# PHP拡張機能のインストール
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd mysqli

# Composerのインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Xdebugのインストールと有効化
RUN pecl install xdebug \
  && docker-php-ext-enable xdebug

# Xdebugの設定
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
  && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Composerのインストール
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Laravelプロジェクトの作成
RUN composer create-project --prefer-dist laravel/laravel /var/www/html

# 作業ディレクトリの設定
WORKDIR /var/www/html

# ソースコードのコピー
COPY . /var/www/html
COPY composer.json /var/www/html/composer.json

# パーミッションの設定
RUN chown -R www-data:www-data /var/www/html
RUN mkdir -p \
  /var/www/html/storage/framework/sessions \
  /var/www/html/storage/framework/views \
  /var/www/html/storage/framework/cache \
  /var/www/html/storage/app/public \
  /var/www/html/bootstrap/cache \
  && chown -R www-data:www-data /var/www/html/storage \
  && chown -R www-data:www-data /var/www/html/bootstrap/cache

# PHPUnitのインストール
RUN composer require --dev phpunit/phpunit

# 環境変数の設定
ENV MYSQL_ROOT_PASSWORD=my-secret-pw
ENV MYSQL_DATABASE=fishpostdb
ENV MYSQL_USER=localhost
ENV MYSQL_PASSWORD=localhost
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

# Apacheの設定
RUN a2enmod rewrite
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

CMD ["apache2-foreground"]