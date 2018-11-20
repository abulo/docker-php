# Version 0.2
# 基础镜像
FROM daocloud.io/abulo/docker-php:php

# 维护者信息
MAINTAINER abulo.hoo@gmail.com

#php 插件
#编译 libsodium-php
RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/jedisct1/libsodium-php.git && cd libsodium-php && git checkout 2.0.10 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && rm -rf /opt/soft

#编译 php-ds
RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/php-ds/extension.git && cd extension && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && rm -rf /opt/soft

#编译 redis 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/redis-4.0.2.tgz && tar -zxf redis-4.0.2.tgz && cd redis-4.0.2 && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && rm -rf /opt/soft

#编译 event 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/event-2.3.0.tgz && tar -zxf event-2.3.0.tgz && cd event-2.3.0 && /usr/local/php/bin/phpize && ./configure   --with-php-config=/usr/local/php/bin/php-config --with-event-core --with-event-extra && make && make install && rm -rf /opt/soft

#编译 yaml 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/yaml-2.0.2.tgz && tar -zxf yaml-2.0.2.tgz && cd yaml-2.0.2 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#编译 msgpack 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/msgpack-2.0.2.tgz && tar -zxf  msgpack-2.0.2.tgz && cd msgpack-2.0.2 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#编译 inotify 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/inotify-2.0.0.tgz  && tar -zxf  inotify-2.0.0.tgz  && cd inotify-2.0.0 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#编译 mongodb 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/mongodb-1.4.4.tgz && tar -zxf mongodb-1.4.4.tgz && cd mongodb-1.4.4 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#敏感词过滤PHP 扩展
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  https://github.com/abulo/php-ext-trie-filter/archive/v1.0.tar.gz && tar zxvf v1.0.tar.gz  && cd php-ext-trie-filter-1.0  &&  /usr/local/php/bin/phpize &&  ./configure   --with-php-config=/usr/local/php/bin/php-config  --with-trie_filter=/usr/local/libdatrie && make && make install && rm -rf /opt/soft

#编译 imagick 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  http://pecl.php.net/get/imagick-3.4.3.tgz && tar -zxf imagick-3.4.3.tgz && cd imagick-3.4.3 && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft



#编译智能裁剪图片
RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/abulo/tclip.git --depth=1 && cd tclip/php_ext && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#编译分词
RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/jonnywang/phpjieba.git --depth=1 &&  cd phpjieba/cjieba && make && cd .. && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#编译 swoole
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c  https://github.com/swoole/swoole-src/archive/v4.2.8.tar.gz && tar -zxf v4.2.8.tar.gz  && cd swoole-src-4.2.8  &&  /usr/local/php/bin/phpize && ./configure --enable-debug-log --enable-trace-log --enable-sockets --enable-openssl --enable-http2 --enable-swoole  --enable-mysqlnd --enable-coroutine-postgresql --with-openssl-dir=/usr/local/openssl  --with-jemalloc-dir=/usr/local/jemalloc  --enable-debug --with-nghttp2-dir=/usr/local/include/nghttp2  --with-php-config=/usr/local/php/bin/php-config && make && make install && rm -rf /opt/soft


#copy 配置文件
COPY php-fpm.conf  /usr/local/php/etc/
COPY www.conf  /usr/local/php/etc/php-fpm.d/
COPY php.ini  /usr/local/php/etc/

USER www
WORKDIR /home/www
