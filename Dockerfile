# Version 0.1
# 基础镜像
FROM ubuntu:14.04

# 维护者信息
MAINTAINER abulo.hoo@gmail.com

# 设置源
RUN  sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && groupadd -r www  && useradd -r -g www www && mkdir -pv /home/www && apt-get -y update  && apt-get install --no-install-recommends -y -q libxml2 libxml2-dev build-essential openssl libssl-dev make curl libjpeg-dev libpng-dev libmcrypt-dev libreadline6 libreadline6-dev libmhash-dev libfreetype6-dev libkrb5-dev libc-client2007e libc-client2007e-dev libbz2-dev libxslt1-dev libxslt1.1 libpq-dev libpng12-dev git autoconf automake m4 libmagickcore-dev libmagickwand-dev libcurl4-openssl-dev libltdl-dev libmhash2 libiconv-hook-dev libiconv-hook1 libpcre3-dev libgmp-dev gcc g++ ssh cmake re2c wget cron bzip2 rcconf flex vim bison mawk cpp binutils libncurses5 unzip tar libncurses5-dev libtool libpcre3 libpcrecpp0 zlibc libltdl3-dev slapd ldap-utils db5.1-util libldap2-dev libsasl2-dev net-tools libicu-dev libtidy-dev systemtap-sdt-dev libgmp3-dev gettext libexpat1-dev libz-dev libedit-dev libdmalloc-dev libevent-dev libyaml-dev autotools-dev pkg-config zlib1g-dev libcunit1-dev libev-dev libjansson-dev libc-ares-dev libjemalloc-dev cython python3-dev python-setuptools libreadline-dev perl python3-pip zsh tcpdump strace gdb openbsd-inetd telnetd htop valgrind python2.7-dev libatlas-base-dev gfortran libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libtiff-dev libv4l-dev ant default-jdk checkinstall yasm libjpeg8-dev libtiff4-dev libdc1394-22-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev qt5-default libtbb-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev x264 v4l-utils libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen ca-certificates mercurial bzr libffi-dev && apt-get clean  && rm -rf /var/lib/apt/lists/*  && ln -s /usr/include/x86_64-linux-gnu/gmp.h /usr/include/gmp.h  && ln -s /usr/lib/x86_64-linux-gnu/libldap.so /usr/lib/  && ln -s /usr/lib/x86_64-linux-gnu/liblber.so /usr/lib/  && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so  && ln -s /usr/lib/libiconv_hook.so.1.0.0 /usr/lib/libiconv.so.1;

#编译 Cmake
RUN mkdir -pv /opt/soft && cd /opt/soft  && wget -nv https://cmake.org/files/v3.6/cmake-3.6.3.tar.gz && tar -zxf cmake-3.6.3.tar.gz && cd cmake-3.6.3 && ./bootstrap && make && make install  && rm -rf /opt/soft

# 编译openssl
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -nv https://www.openssl.org/source/openssl-1.0.2l.tar.gz  && tar -zxf openssl-1.0.2l.tar.gz  && cd openssl-1.0.2l  &&  ./config shared --prefix=/usr/local/openssl --openssldir=/usr/lib/openssl   && make  && make install  && rm -rf /opt/soft

#python 插件
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -nv https://bootstrap.pypa.io/get-pip.py && python get-pip.py && python -mpip install -U pyopenssl ndg-httpsclient pyasn1 && python -mpip install --upgrade pip && python get-pip.py && python -mpip install -U numpy && python -mpip install -U matplotlib --ignore-installed six && rm -rf /opt/soft;
