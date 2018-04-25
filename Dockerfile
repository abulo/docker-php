# Version 0.1
# 基础镜像
FROM ubuntu:16.04

# 维护者信息
MAINTAINER abulo.hoo@gmail.com


ARG LDAP_DOMAIN=acntech.no
ARG LDAP_ORG=AcnTech
ARG LDAP_HOSTNAME=ldap.acntech.internal
ARG LDAP_PASSWORD=welcome1

# 设置源
RUN groupadd -r www && useradd -r -g www www && mkdir -pv /home/www && sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list &&  apt-get -y update && apt-get -y -o Dpkg::Options::="--force-confdef" upgrade && apt-get -y dist-upgrade &&  apt-get -y install apt-utils sudo net-tools rsyslog vim ca-certificates && echo "slapd slapd/root_password password ${LDAP_PASSWORD}" | debconf-set-selections && echo "slapd slapd/root_password_again password ${LDAP_PASSWORD}" | debconf-set-selections && echo "slapd slapd/internal/adminpw password ${LDAP_PASSWORD}" | debconf-set-selections &&  echo "slapd slapd/internal/generated_adminpw password ${LDAP_PASSWORD}" | debconf-set-selections && echo "slapd slapd/password2 password ${LDAP_PASSWORD}" | debconf-set-selections && echo "slapd slapd/password1 password ${LDAP_PASSWORD}" | debconf-set-selections && echo "slapd slapd/domain string ${LDAP_DOMAIN}" | debconf-set-selections && echo "slapd shared/organization string ${LDAP_ORG}" | debconf-set-selections && echo "slapd slapd/backend string HDB" | debconf-set-selections && echo "slapd slapd/purge_database boolean true" | debconf-set-selections && echo "slapd slapd/move_old_database boolean true" | debconf-set-selections && echo "slapd slapd/allow_ldap_v2 boolean false" | debconf-set-selections && echo "slapd slapd/no_configuration boolean false" | debconf-set-selections && apt-get install --no-install-recommends -y -q --force-yes libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0v5 zlibc libltdl3-dev slapd ldap-utils db5.3-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl python3-pip zsh tcpdump strace gdb openbsd-inetd telnetd htop valgrind ant default-jdk ffmpeg qtbase5-dev python-dev python-numpy python3-numpy libopencv-dev libgtk-3-dev libdc1394-22 libdc1394-22-dev libtiff5-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev v4l-utils vtk6 liblapacke-dev libopenblas-dev libgdal-dev checkinstall x264 libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen ca-certificates mercurial bzr libffi-dev qt5-default libvtk6-dev libwebp-dev libopenexr-dev libx264-dev yasm python-tk python3-tk && apt-get clean && rm -rf /var/lib/apt/lists/* && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/ && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/ && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1


ENV GOROOT /usr/local/go
ENV GOPATH /data/go
ENV PATH $GOROOT/bin:$PATH
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -nv https://storage.googleapis.com/golang/go1.10.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.10.1.linux-amd64.tar.gz  && mkdir -pv /data/go && go version && go version && rm -rf /opt/soft;

#编译 Cmake
RUN mkdir -pv /opt/soft && cd /opt/soft  && wget -nv https://cmake.org/files/v3.11/cmake-3.11.1.tar.gz && tar -zxf cmake-3.11.1.tar.gz && cd cmake-3.11.1 && ./bootstrap && make && make install  && rm -rf /opt/soft

# 编译openssl
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -nv https://www.openssl.org/source/openssl-1.0.2o.tar.gz  && tar -zxf openssl-1.0.2o.tar.gz  && cd openssl-1.0.2o  &&  ./config shared --prefix=/usr/local/openssl --openssldir=/usr/lib/openssl   && make  && make install  && rm -rf /opt/soft

#python 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -nv https://bootstrap.pypa.io/get-pip.py && python get-pip.py && python -mpip install -U pyopenssl ndg-httpsclient pyasn1 && python -mpip install --upgrade pip && python get-pip.py && python -mpip install -U numpy && python -mpip install -U matplotlib --ignore-installed six && rm -rf /opt/soft;
