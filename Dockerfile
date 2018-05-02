# Version 0.2
# 基础镜像
FROM daocloud.io/abulo/docker-php:base

# 维护者信息
MAINTAINER abulo.hoo@gmail.com

#安装opencv2.0	 #安装opencv2.0
RUN mkdir -pv /opt/soft && cd /opt/soft && wget https://github.com/opencv/opencv/archive/2.4.4.tar.gz && tar -zxf 2.4.4.tar.gz && cd opencv-2.4.4/ && cmake CMakeLists.txt && make && make install && export PKG_CONFIG_PATH=/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && echo "/usr/local/lib/" > /etc/ld.so.conf.d/opencv.conf  && ldconfig && rm -rf /opt/soft


RUN mkdir -pv /opt/soft && cd /opt/soft && git clone https://github.com/abulo/tclip.git --depth=1 && cd tclip/php_ext && /usr/local/php/bin/phpize && ./configure  --with-php-config=/usr/local/php/bin/php-config  && make && make install && rm -rf /opt/soft

#copy 配置文件
COPY php-fpm.conf  /usr/local/php/etc/
COPY www.conf  /usr/local/php/etc/php-fpm.d/
COPY php.ini  /usr/local/php/etc/

USER www
WORKDIR /home/www
