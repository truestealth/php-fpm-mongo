FROM bitnami/minideb-runtimes:jessie-php
LABEL maintainer "Bitnami <containers@bitnami.com>"

# Install required system packages and dependencies
RUN install_packages ca-certificates libbz2-1.0 libc6 libcomerr2 libcurl3 libffi6 libfreetype6 libgcc1 libgcrypt20 libgmp10 libgnutls-deb0-28 libgpg-error0 libgssapi-krb5-2 libhogweed2 libicu52 libidn11 libjpeg62-turbo libk5crypto3 libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 liblzma5 libncurses5 libnettle4 libp11-kit0 libpng12-0 libpq5 libreadline6 librtmp1 libsasl2-2 libssh2-1 libssl1.0.0 libstdc++6 libsybdb5 libtasn1-6 libtidy-0.99-0 libtinfo5 libxml2 libxslt1.1 wget zlib1g
RUN wget -nc -P /tmp/bitnami/pkg/cache/ https://downloads.bitnami.com/files/stacksmith/php-7.2.7-3-linux-x64-debian-8.tar.gz && \
    echo "5b66527477241dd41ccf232e49cab4fcda740b49a0f4d4b6b1dc8b659dfe265c  /tmp/bitnami/pkg/cache/php-7.2.7-3-linux-x64-debian-8.tar.gz" | sha256sum -c - && \
    tar -zxf /tmp/bitnami/pkg/cache/php-7.2.7-3-linux-x64-debian-8.tar.gz -P --transform 's|^[^/]*/files|/opt/bitnami|' --wildcards '*/files' && \
    rm -rf /tmp/bitnami/pkg/cache/php-7.2.7-3-linux-x64-debian-8.tar.gz
RUN mkdir -p /bitnami && ln -sf /bitnami/php /bitnami/php-fpm
RUN mkdir /opt/bitnami/php/logs && touch /opt/bitnami/php/logs/php-fpm.log

RUN install_packages gcc make autoconf
RUN /opt/bitnami/php/bin/pecl install mongodb
RUN echo "extension=mongodb.so" >> /opt/bitnami/php/etc/php.ini

ENV BITNAMI_APP_NAME="php-fpm" \
    BITNAMI_IMAGE_VERSION="7.2.7-debian-8-r27" \
    PATH="/opt/bitnami/php/bin:/opt/bitnami/php/sbin:/opt/bitnami/php/sbin:$PATH"

EXPOSE 9000

WORKDIR /app
CMD ["php-fpm","-F","--pid","/opt/bitnami/php/tmp/php-fpm.pid","-y","/opt/bitnami/php/etc/php-fpm.conf"]