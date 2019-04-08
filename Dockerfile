# Version 0.2
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
	apt-get install --no-install-recommends -y -q  libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0v5 zlibc libltdl3-dev slapd ldap-utils db5.3-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl python3-pip zsh tcpdump strace gdb openbsd-inetd telnetd htop valgrind jpegoptim optipng pngquant iputils-ping gifsicle imagemagick libmagick++-dev && curl -sL https://deb.nodesource.com/setup_10.x | bash -  && apt-get install -y nodejs && npm install -g svgo && apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/ && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1

#编译 Cmake
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://cmake.org/files/v3.11/cmake-3.11.1.tar.gz && tar -zxf cmake-3.11.1.tar.gz && cd cmake-3.11.1 && ./bootstrap && make && make install && rm -rf /opt/soft && rm -rf  /var/tmp/* /tmp/*
#编译 OpenSSL
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://www.openssl.org/source/openssl-1.0.2o.tar.gz && tar -zxf openssl-1.0.2o.tar.gz && cd openssl-1.0.2o && ./config shared --prefix=/usr/local/openssl --openssldir=/usr/lib/openssl && make && make install && rm -rf /opt/soft \
\
#编译 hiredis
&& mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://github.com/redis/hiredis/archive/v0.13.3.tar.gz && tar -xzf v0.13.3.tar.gz && cd hiredis-0.13.3 && make -j && make install && ldconfig && mkdir -pv /usr/lib/hiredis && cp libhiredis.so /usr/lib/hiredis && mkdir -pv /usr/include/hiredis &&  cp hiredis.h /usr/include/hiredis && rm -rf /opt/soft \
\
#编译 inotify-tools
&& mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://github.com/rvoicilas/inotify-tools/archive/3.20.1.tar.gz && tar -zxf 3.20.1.tar.gz && cd inotify-tools-3.20.1 && ./autogen.sh && ./configure && make && make install && ln -sv /usr/local/lib/libinotify* /usr/lib/ &&  rm -rf /opt/soft \
\
#编译 nghttp2
&& mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://github.com/nghttp2/nghttp2/releases/download/v1.32.0/nghttp2-1.32.0.tar.gz && tar -zxf nghttp2-1.32.0.tar.gz && cd nghttp2-1.32.0 && ./configure && make && make install && ldconfig && rm -rf /opt/soft \
\
#编译 jemalloc
&& mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://github.com/jemalloc/jemalloc/releases/download/4.0.4/jemalloc-4.0.4.tar.bz2 && tar -jxf jemalloc-4.0.4.tar.bz2 && cd jemalloc-4.0.4/ && ./configure --with-jemalloc-prefix=je_ --prefix=/usr/local/jemalloc && make && make install && rm -rf /opt/soft \
\
#编译 libsodium
&& mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv https://github.com/jedisct1/libsodium/archive/1.0.16.tar.gz && tar -zxf 1.0.16.tar.gz &&  cd libsodium-1.0.16  && ./autogen.sh && ./configure && make && make check && make install  && rm -rf /opt/soft \
\
#敏感词过滤
&& mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv ftp://linux.thai.net/pub/ThaiLinux/software/libthai/libdatrie-0.2.5.tar.gz && tar -zxf libdatrie-0.2.5.tar.gz && cd  libdatrie-0.2.5 && ./configure  --prefix=/usr/local/libdatrie && make && make install && rm -rf /opt/soft && rm -rf  /var/tmp/* /tmp/*
#安装opencv2.0	 #安装opencv2.0
RUN mkdir -pv /opt/soft && cd /opt/soft && wget https://github.com/opencv/opencv/archive/2.4.4.tar.gz && tar -zxf 2.4.4.tar.gz && cd opencv-2.4.4/ && cmake CMakeLists.txt && make && make install && export PKG_CONFIG_PATH=/usr/lib/pkgconfig/:/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && echo "/usr/local/lib/" > /etc/ld.so.conf.d/opencv.conf  && ldconfig && rm -rf /opt/soft && rm -rf  /var/tmp/* /tmp/*
