# Version 0.1
# 基础镜像
FROM ubuntu:14.04

# 维护者信息
MAINTAINER abulo.hoo@gmail.com


# 设置源
# RUN  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get -y update && apt-get install -y  libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0 zlibc libltdl3-dev slapd ldap-utils db5.1-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl g++ make binutils autoconf automake autotools-dev libtool pkg-config zlib1g-dev libcunit1-dev libssl-dev libxml2-dev libev-dev libevent-dev libjansson-dev libc-ares-dev libjemalloc-dev  cython python3-dev python-setuptools && apt-get clean && rm -rf /var/lib/apt/lists/*

#建立软连接
RUN ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/ && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1

#编译 openssl
RUN mkdir -p /opt/soft && cd /opt/soft && wget https://www.openssl.org/source/openssl-1.0.2l.tar.gz && tar -zxf openssl-1.0.2l.tar.gz && cd openssl-1.0.2l && ./config shared --prefix=/usr/local/openssl --openssldir=/usr/lib/openssl && make && make install

#编译 hiredis
RUN cd /opt/soft && git clone https://github.com/redis/hiredis && cd hiredis && make -j && make install && ldconfig && mkdir -pv /usr/lib/hiredis && cp libhiredis.so /usr/lib/hiredis && mkdir -pv /usr/include/hiredis &&  cp hiredis.h /usr/include/hiredis

#编译 inotify-tools
RUN cd /opt/soft && git clone https://github.com/rvoicilas/inotify-tools.git && cd inotify-tools && ./autogen.sh && ./configure && make && make install && ln -sv /usr/local/lib/libinotify* /usr/lib/

# 编译 PHP
RUN cd /opt/soft && wget -c http://php.net/distributions/php-7.1.7.tar.gz && groupadd www && useradd -g www www

#编译 php
RUN cd /opt/soft && tar -zxf php-7.1.7.tar.gz &&  cd php-7.1.7 && ./buildconf --force && ./configure --prefix=/usr/local/php --with-config-file-path=/usr/local/php/etc --enable-bcmath --enable-calendar  --enable-exif --enable-ftp --enable-gd-native-ttf --enable-intl --enable-mbregex --enable-mbstring --enable-shmop --enable-soap --enable-sockets --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-wddx --enable-dba --enable-zip --with-freetype-dir --with-gd --with-gettext --with-iconv --with-icu-dir=/usr --with-jpeg-dir --with-kerberos --with-libedit --with-mhash --with-openssl  --with-png-dir --with-xmlrpc --with-zlib --with-zlib-dir --with-bz2 --enable-fpm --with-fpm-user=www --with-fpm-group=www --with-gmp --with-curl --with-xsl --with-ldap --with-ldap-sasl=/usr --enable-pcntl --with-tidy --enable-zend-signals --enable-dtrace  --with-mysqli=mysqlnd   --with-pdo-mysql=mysqlnd  --enable-pdo  --enable-opcache --with-mcrypt --enable-gd-jis-conv --with-imap --with-imap-ssl --with-libxml-dir --enable-shared --with-pcre-regex  --with-sqlite3 --with-cdb  --enable-fileinfo --enable-filter --with-pcre-dir  --with-openssl-dir  --enable-json  --enable-mbregex-backtrack  --with-onig  --with-pdo-sqlite --with-readline --enable-session --enable-simplexml   --enable-mysqlnd-compression-support --with-pear && sed -i 's/EXTRA_LIBS.*/& -llber/g' Makefile && make && make install

#--enable-maintainer-zts

#编译 redis 插件
RUN cd /opt/soft && wget -c http://pecl.php.net/get/redis-3.1.3.tgz && tar -zxf redis-3.1.3.tgz && cd redis-3.1.3 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install

#编译 event 插件
RUN cd /opt/soft && wget -c http://pecl.php.net/get/event-2.3.0.tgz && tar -zxf event-2.3.0.tgz && cd event-2.3.0 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --with-event-core --with-event-extra && make && make install

#编译pthreads
#RUN cd /opt/soft && git clone https://github.com/krakjoe/pthreads.git && cd pthreads && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --enable-pthreads --with-pthreads-sanitize --with-pthreads-dmalloc  --with-php-config=/usr/local/php/bin/php-config && make && make install

#编译nghttp2
RUN cd /opt/soft && git clone https://github.com/nghttp2/nghttp2.git && cd nghttp2 && git submodule update --init && autoreconf -i && automake && automake && ./configure && make && make install

#编译yaml
RUN cd /opt/soft && wget http://pecl.php.net/get/yaml-2.0.0.tgz && tar zxvf yaml-2.0.0.tgz && cd yaml-2.0.0 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install

#编译msgpack
RUN cd /opt/soft && wget http://pecl.php.net/get/msgpack-2.0.2.tgz && tar zxvf  msgpack-2.0.2.tgz && cd msgpack-2.0.2 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install

#编译inotify
RUN cd /opt/soft && wget http://pecl.php.net/get/inotify-2.0.0.tgz  && tar zxvf  inotify-2.0.0.tgz  && cd inotify-2.0.0 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install

#编译mongodb
RUN cd /opt/soft && wget -c https://pecl.php.net/get/mongodb-1.2.9.tgz && tar zxvf mongodb-1.2.9.tgz && cd mongodb-1.2.9 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install

#安装opencv2.0
RUN cd /opt/soft && wget https://github.com/opencv/opencv/archive/2.4.4.tar.gz && tar xvf 2.4.4.tar.gz && cd opencv-2.4.4/ && cmake CMakeLists.txt && make -j $(cat /proc/cpuinfo|grep processor|wc -l) && make install && export PKG_CONFIG_PATH=/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && echo "/usr/local/lib/" > /etc/ld.so.conf.d/opencv.conf  && ldconfig

#安装php-tclip扩展
#RUN cd /opt/soft && git clone https://github.com/exinnet/tclip.git && cd tclip/php_ext && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && cp modules/tclip.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20160303/

RUN cd /opt/soft && git clone https://github.com/jonnywang/tclip.git && cd tclip/php_ext && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install
# && cp modules/tclip.so /usr/local/php/lib/php/extensions/no-debug-non-zts-20160303/

#编译pthreads
#RUN cd /opt/soft && git clone https://github.com/krakjoe/pthreads.git && cd pthreads && git checkout 0431334ab0472dccbb8fdb2ae8d4885490d6f65a && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config --enable-pthreads --with-pthreads-sanitize --with-pthreads-dmalloc  --with-php-config=/usr/local/php/bin/php-config && make && make install

#编译swoole
RUN cd /opt/soft && wget -c  https://github.com/swoole/swoole-src/archive/v2.0.7.tar.gz && tar -zxf v2.0.7.tar.gz  && cd swoole-src-2.0.7  && /usr/local/php/bin/phpize && ./configure --enable-swoole-debug --enable-sockets --enable-openssl --with-openssl-dir=/usr/local/openssl --enable-http2 --enable-async-redis --enable-swoole  --enable-coroutine --enable-timewheel --enable-mysqlnd  --with-php-config=/usr/local/php/bin/php-config  && make && make install
#--enable-thread
#copy 配置文件
COPY php-fpm.conf  /usr/local/php/etc/
COPY www.conf  /usr/local/php/etc/php-fpm.d/
COPY php.ini  /usr/local/php/etc/
#COPY php-cli.ini  /usr/local/php/etc/

RUN cp /opt/soft/php-7.1.7/sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm &&   apt-get clean

#EXPOSE 9000
#CMD /usr/local/php/sbin/php-fpm  --nodaemonize --fpm-config /usr/local/php/etc/php-fpm.conf
#docker network create --driver=bridge --subnet=192.168.0.0/24 --gateway=192.168.0.1 mynet
#docker run --ip=192.168.0.10 --net=mynet -ti some_image
#docker run -it -d --name pushmedia  abulo/lnmp
#docker run -it -d   -p 10.0.11.253:8888:80 -v /Users/abulo/Work/php/:/home/work/  --name pushmedia  abulo/lnmp:1.0
#docker run -id -p 80:80 -v /Users/abulo/Work/php:/home/work/  --name pushmedia  abulo/lnmp:1.0
#docker run --name lnmp -dit -p 80:80 -p 3306:3306  -v /Users/abulo/Work/php/:/home/work/ abulo/lnmp
#docker exec -it pushmedia /bin/bash
#docker rm $(docker ps -a -q)
#docker rmi $(docker images -q)


#http://0d1b43cf.m.daocloud.io
