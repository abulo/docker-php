# Version 0.1
# 基础镜像
FROM daocloud.io/abulo/docker-php:base

# 维护者信息
MAINTAINER abulo.hoo@gmail.com

#sed -i 's/mirrors.aliyun.com/archive.ubuntu.com/' /etc/apt/sources.list &&

RUN apt-get -y update && apt-get install --no-install-recommends -y  gfortran libjasper-dev libgtk2.0-dev libavcodec-dev libavformat-dev libswscale-dev libtiff-dev libv4l-dev ant default-jdk checkinstall yasm libjpeg8-dev libtiff5-dev libdc1394-22-dev libxine2-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev qt5-default libtbb-dev libfaac-dev libmp3lame-dev libtheora-dev libvorbis-dev libxvidcore-dev libopencore-amrnb-dev libopencore-amrwb-dev x264 v4l-utils libprotobuf-dev protobuf-compiler libgoogle-glog-dev libgflags-dev libgphoto2-dev libeigen3-dev libhdf5-dev doxygen ca-certificates mercurial bzr libffi-dev libtbb2 && apt-get clean && rm -rf /var/lib/apt/lists/*


ENV GOROOT /usr/local/go
ENV GOPATH /data/go
ENV PATH $GOROOT/bin:$PATH
ENV PATH $PATH:$GOROOT/bin:$GOPATH/bin

#安装 golang
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv  --no-check-certificate https://studygolang.com/dl/golang/go1.10.1.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.10.1.linux-amd64.tar.gz  && mkdir -pv /data/go && go version && rm -rf /opt/soft;


#安装 opencv3
RUN mkdir -pv /opt/soft && cd /opt/soft && wget -c -nv -O opencv.tar.gz https://github.com/opencv/opencv/archive/3.4.1.tar.gz && tar -xzf opencv.tar.gz &&  wget -c -nv  -O opencv_contrib.tar.gz https://github.com/opencv/opencv_contrib/archive/3.4.1.tar.gz && tar -xzf opencv_contrib.tar.gz && cd opencv-3.4.1 && rm -rf build && mkdir build && cd build && \
	cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=/opt/soft/opencv_contrib-3.4.1/modules \
    -D BUILD_DOCS=OFF BUILD_EXAMPLES=OFF \
    -D WITH_GTK=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_opencv_java=OFF \
    -D BUILD_opencv_python=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=OFF .. \
    && make -j $(nproc) \
    && make install \
    && ldconfig  && rm -rf /opt/soft;

#配置环境变量
ENV PKG_CONFIG_PATH /usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH /usr/local/lib
ENV CGO_CPPFLAGS -I/usr/local/include
ENV CGO_CXXFLAGS "--std=c++1z"
ENV CGO_LDFLAGS "-L/usr/local/lib -lopencv_core -lopencv_face -lopencv_videoio -lopencv_imgproc -lopencv_highgui -lopencv_imgcodecs -lopencv_objdetect -lopencv_features2d -lopencv_video -lopencv_dnn -lopencv_xfeatures2d -lopencv_plot -lopencv_tracking"

RUN mkdir -pv /opt/soft && cd /opt/soft && go get -u -d gocv.io/x/gocv && cd $GOPATH/src/gocv.io/x/gocv && go run ./cmd/version/main.go && go get -u -f github.com/esimov/caire/cmd/caire && go install && caire --help

USER www
WORKDIR /home/www
