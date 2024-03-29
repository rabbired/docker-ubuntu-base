FROM ubuntu:18.04

MAINTAINER rabbired@outlook.com RedZ

ENV DEBIAN_FRONTEND noninteractive
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

RUN sed -i 's/security.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g' /etc/apt/sources.list && \
    apt-get update && apt-get upgrade -yqq && \
    apt-get install -yqq locales \
        software-properties-common \
        sudo tzdata ca-certificates \
        curl wget nano rsyslog inotify-tools

ENV UID=1000
ENV GID=1000
ENV UNAME=app
ENV UPASS=passwd
ENV UDIR=/home/$UNAME
ENV UMASK=022

ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8
ENV TZ=Asia/Shanghai

RUN echo LANG=$LANG > /etc/default/locale && \
    echo LANGUAGE=$LANGUAGE >> /etc/default/locale && \
    echo LC_ALL=$LC_ALL >> /etc/default/locale && \
    echo $TZ > /etc/timezone && \
    locale-gen $LANG && \
    update-locale $LANG && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata && \
    useradd -s /bin/bash -K UMASK=$UMASK -md $UDIR $UNAME && \
    echo "$UNAME:$UPASS" | chpasswd && \
    echo "$UNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    apt-get -y autoclean && apt-get -y autoremove --purge && \
    apt-get -y purge $(dpkg --get-selections | grep deinstall | sed s/deinstall//g) && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm -rf /var/cache/* /root/sources/*

USER $UNAME

WORKDIR $UDIR

ADD start.sh /start.sh

CMD ["bash","/start.sh"]
