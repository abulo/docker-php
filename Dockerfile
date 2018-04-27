# Version 0.1
# 基础镜像
FROM ubuntu:16.04

# 维护者信息
MAINTAINER abulo.hoo@gmail.com

ARG LDAP_DOMAIN=localhost
ARG LDAP_ORG=ldap
ARG LDAP_HOSTNAME=localhost
ARG LDAP_PASSWORD=ldap


# 设置源
RUN  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
	groupadd -r www && \
	useradd -r -g www www && \
	mkdir -pv /home/www && \
	apt-get -y update && \
	echo "slapd slapd/root_password password ${LDAP_PASSWORD}" | debconf-set-selections && \
	echo "slapd slapd/root_password_again password ${LDAP_PASSWORD}" | debconf-set-selections && \
	echo "slapd slapd/internal/adminpw password ${LDAP_PASSWORD}" | debconf-set-selections &&  \
	echo "slapd slapd/internal/generated_adminpw password ${LDAP_PASSWORD}" | debconf-set-selections && \
	echo "slapd slapd/password2 password ${LDAP_PASSWORD}" | debconf-set-selections && \
	echo "slapd slapd/password1 password ${LDAP_PASSWORD}" | debconf-set-selections && \
	echo "slapd slapd/domain string ${LDAP_DOMAIN}" | debconf-set-selections && \
	echo "slapd shared/organization string ${LDAP_ORG}" | debconf-set-selections && \
	echo "slapd slapd/backend string HDB" | debconf-set-selections && \
	echo "slapd slapd/purge_database boolean true" | debconf-set-selections && \
	echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && \
	echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && \
	echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && \
	apt-get install --no-install-recommends -y -q  libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0v5 zlibc libltdl3-dev slapd ldap-utils db5.3-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl  python3-pip zsh tcpdump strace gdb openbsd-inetd telnetd htop valgrind python-pip python-dev python-numpy python-scipy python3-numpy python3-scipy libopencv-dev mercurial bzr && apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/ && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1

#编译GO
RUN mkdir -pv /opt/soft && \
	cd /opt/soft && \
	echo "编译 Cmake" && \
	wget -c -nv  https://cmake.org/files/v3.11/cmake-3.11.1.tar.gz && tar -zxf cmake-3.11.1.tar.gz && cd cmake-3.11.1 && ./bootstrap && make && make install  && \
	cd /opt/soft && \
	echo "编译 openssl" && \
	wget -c -nv  https://www.openssl.org/source/openssl-1.0.2o.tar.gz  && tar -zxf openssl-1.0.2o.tar.gz  && cd openssl-1.0.2o  &&  ./config shared --prefix=/usr/local/openssl --openssldir=/usr/lib/openssl   && make  && make install  && \
	cd /opt/soft && \
	echo "编译 hiredis" && \
	wget -c -nv  https://github.com/redis/hiredis/archive/v0.13.3.tar.gz && tar -xzf v0.13.3.tar.gz && cd hiredis-0.13.3 && make -j && make install && ldconfig && mkdir -pv /usr/lib/hiredis && cp libhiredis.so /usr/lib/hiredis && mkdir -pv /usr/include/hiredis &&  cp hiredis.h /usr/include/hiredis && \
	cd /opt/soft && \
	echo "编译 inotify-tools" && \
 	wget -c -nv  https://github.com/rvoicilas/inotify-tools/archive/3.20.1.tar.gz && tar -zxf 3.20.1.tar.gz && cd inotify-tools-3.20.1 && ./autogen.sh && ./configure && make && make install && ln -sv /usr/local/lib/libinotify* /usr/lib/ && \
	cd /opt/soft && \
	echo "编译 nghttp2" && \
	wget -c -nv  https://github.com/nghttp2/nghttp2/releases/download/v1.31.1/nghttp2-1.31.1.tar.gz && tar -zxf nghttp2-1.31.1.tar.gz && cd nghttp2-1.31.1 && ./configure && make && make install && \
	cd /opt/soft && \
	echo "编译 jemalloc" && \
	wget -c -nv  https://github.com/jemalloc/jemalloc/releases/download/4.0.4/jemalloc-4.0.4.tar.bz2 &&  tar -jxvf jemalloc-4.0.4.tar.bz2 && cd jemalloc-4.0.4/ && ./configure --with-jemalloc-prefix=je_ --prefix=/usr/local/jemalloc && make && make install && \
	cd /opt/soft && \
	echo "编译 libsodium" && \
	wget -c -nv  https://github.com/jedisct1/libsodium/archive/1.0.16.tar.gz && tar -zxf 1.0.16.tar.gz &&  cd libsodium-1.0.16  && ./autogen.sh && ./configure && make && make check && make install  && \
	cd /opt/soft && \
	echo "敏感词过滤" && \
	wget -c -nv  ftp://linux.thai.net/pub/ThaiLinux/software/libthai/libdatrie-0.2.5.tar.gz && tar -zxf libdatrie-0.2.5.tar.gz && cd  libdatrie-0.2.5 && ./configure  --prefix=/usr/local/libdatrie && make && make install && rm -rf /opt/soft

#安装opencv2.0
#RUN mkdir -pv /opt/soft && cd /opt/soft && wget https://github.com/opencv/opencv/archive/2.4.4.tar.gz && tar -zxf 2.4.4.tar.gz && cd opencv-2.4.4/ && cmake CMakeLists.txt && make && make install && export PKG_CONFIG_PATH=/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && echo "/usr/local/lib/" > /etc/ld.so.conf.d/opencv.conf  && ldconfig && rm -rf /opt/soft


# 编译 PHP
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://cn2.php.net/distributions/php-7.1.16.tar.gz && tar -zxf php-7.1.16.tar.gz &&  cd php-7.1.16 && ./buildconf --force && ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --with-config-file-scan-dir=/usr/local/php/etc/php.d --enable-bcmath --enable-calendar  --enable-exif --enable-ftp --enable-gd-native-ttf --enable-intl --enable-mbregex --enable-mbstring --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --enable-dba --enable-zip --with-freetype-dir --with-gd --with-gettext --with-iconv --with-icu-dir=/usr --with-jpeg-dir --with-kerberos --with-libedit --with-mhash --with-openssl  --with-png-dir --with-xmlrpc --with-zlib --with-zlib-dir --with-bz2 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-gmp --with-curl --with-xsl --with-ldap --with-ldap-sasl=/usr --enable-pcntl --with-tidy --enable-zend-signals --enable-dtrace  --with-mysqli=mysqlnd   --with-pdo-mysql=mysqlnd  --enable-pdo  --enable-opcache --with-mcrypt --enable-gd-jis-conv --with-imap --with-imap-ssl --with-libxml-dir --enable-shared --with-pcre-regex  --with-sqlite3 --with-cdb  --enable-fileinfo --enable-filter --with-pcre-dir  --with-openssl-dir  --enable-json  --enable-mbregex-backtrack  --with-onig  --with-pdo-sqlite --with-readline --enable-session --enable-simplexml   --enable-mysqlnd-compression-support --with-pear && sed -i 's/EXTRA_LIBS.*/& -llber/g' Makefile && make && make install && cp /opt/soft/php-7.1.16/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm && rm -rf /opt/soft && ln -s /usr/local/php/bin/* /usr/local/bin/

#php 插件
RUN mkdir -pv /opt/soft && \
	cd /opt/soft && \
	echo "编译 libsodium-php" && \
	git clone https://github.com/jedisct1/libsodium-php.git && cd libsodium-php && git checkout 2.0.10 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && \
	cd /opt/soft && \
	echo "编译 php-ds" && \
	git clone https://github.com/php-ds/extension.git && cd extension && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && \
	cd /opt/soft && \
	echo "编译 redis 插件" && \
	wget -c -nv  http://pecl.php.net/get/redis-4.0.2.tgz && tar -zxf redis-4.0.2.tgz && cd redis-4.0.2 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && \
	cd /opt/soft && \
	echo "编译 event 插件" && \
	wget -c -nv  http://pecl.php.net/get/event-2.3.0.tgz && tar -zxf event-2.3.0.tgz && cd event-2.3.0 && /usr/local/php/bin/phpize && ./configure   --with-php-config=/usr/local/php/bin/php-config --with-event-core --with-event-extra && make && make install && \
	cd /opt/soft && \
	echo "编译 yaml 插件" && \
	wget -c -nv  http://pecl.php.net/get/yaml-2.0.2.tgz && tar -zxf yaml-2.0.2.tgz && cd yaml-2.0.2 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && \
	cd /opt/soft && \
	echo "编译 msgpack 插件" && \
	wget -c -nv  http://pecl.php.net/get/msgpack-2.0.2.tgz && tar -zxf  msgpack-2.0.2.tgz && cd msgpack-2.0.2 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && \
	cd /opt/soft && \
	echo "编译 inotify 插件" && \
	wget -c -nv  http://pecl.php.net/get/inotify-2.0.0.tgz  && tar -zxf  inotify-2.0.0.tgz  && cd inotify-2.0.0 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && \
	cd /opt/soft && \
	echo "编译 mongodb 插件" && \
	wget -c -nv  http://pecl.php.net/get/mongodb-1.4.3.tgz && tar -zxf mongodb-1.4.3.tgz && cd mongodb-1.4.3 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && \
	cd /opt/soft && \
	echo "敏感词过滤PHP 扩展" && \
	wget -c -nv  https://github.com/abulo/php-ext-trie-filter/archive/v1.0.tar.gz && tar zxvf v1.0.tar.gz  && cd php-ext-trie-filter-1.0  &&  /usr/local/php/bin/phpize &&  ./configure   --with-php-config=/usr/local/php/bin/php-config  --with-trie_filter=/usr/local/libdatrie && make && make install && \
	cd /opt/soft && \
	echo "编译PHP-X" && \
	git clone https://github.com/swoole/PHP-X.git && cd PHP-X && cmake . -DPHP_CONFIG_DIR=/usr/local/php/bin && cmake . && make install && \
	cd /opt/soft && \
	echo "编译swoole" && \
	wget -c -nv  https://github.com/swoole/swoole-src/archive/v2.1.3.tar.gz && tar -zxf v2.1.3.tar.gz  && cd swoole-src-2.1.3  &&  /usr/local/php/bin/phpize && ./configure  --enable-swoole-debug --enable-sockets --enable-openssl --with-openssl-dir=/usr/local/openssl --enable-http2 --enable-async-redis --enable-swoole  --enable-coroutine --enable-timewheel --enable-mysqlnd --with-jemalloc-dir=/usr/local/jemalloc --enable-coroutine-postgresql --with-php-config=/usr/local/php/bin/php-config  && make && make install && \
	rm -rf /opt/soft





#智能截图
#RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/abulo/tclip.git --depth=1 && cd tclip/php_ext && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft



#编译 PHP-X
#RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/swoole/PHP-X.git && cd PHP-X && cmake . -DPHP_CONFIG_DIR=/usr/local/php/bin && cmake . && make install &&  rm -rf /opt/soft

#编译swoole
#RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c  https://github.com/swoole/swoole-src/archive/v2.1.1.tar.gz && tar -zxf v2.1.1.tar.gz  && cd swoole-src-2.1.1  &&  sed -i '970c char *buf = (char*) sw_malloc(buf_len);' src/core/base.c  &&  sed -i '975c void *tmp = sw_realloc(buf, buf_len);' src/core/base.c &&  /usr/local/php/bin/phpize && ./configure       --enable-swoole-debug --enable-sockets --enable-openssl --with-openssl-dir=/usr/local/openssl --enable-http2 --enable-async-redis --enable-swoole  --enable-coroutine --enable-timewheel --enable-mysqlnd --with-jemalloc-dir=/usr/local/jemalloc  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft


#RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c  https://github.com/swoole/swoole-src/archive/v2.1.3.tar.gz && tar -zxf v2.1.3.tar.gz  && cd swoole-src-2.1.3  &&  /usr/local/php/bin/phpize && ./configure  --enable-swoole-debug --enable-sockets --enable-openssl --with-openssl-dir=/usr/local/openssl --enable-http2 --enable-async-redis --enable-swoole  --enable-coroutine --enable-timewheel --enable-mysqlnd --with-jemalloc-dir=/usr/local/jemalloc --enable-coroutine-postgresql --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft


#copy 配置文件
COPY php-fpm.conf  /usr/local/php/etc/ \
	 www.conf  /usr/local/php/etc/php-fpm.d/ \
	 php.ini  /usr/local/php/etc/

USER www
WORKDIR /home/www
