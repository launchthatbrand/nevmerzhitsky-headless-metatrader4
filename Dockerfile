FROM ubuntu:16.04
LABEL maintainer="sergey.nevmerzhitsky@gmail.com"

WORKDIR /tmp/

ARG USER=winer
ARG HOME=/home/$USER
ARG USER_ID=1000
ARG GROUP_ID=1010
# To access the values from children containers.
ENV USER=$USER \
    HOME=$HOME
    
ENV WINEARCH=win32 \
    WINEPREFIX=$HOME/.wine \
    DISPLAY=:0 \
    SCREEN_NUM=0 \
    SCREEN_WHD=1366x768x24
ENV MT4DIR=$WINEPREFIX/drive_c/mt4

RUN set -ex; \
    groupadd --gid 1010 $USER;\
    useradd -u $USER_ID -d $HOME -g $USER -ms /bin/bash $USER
    
USER root

RUN set -ex; \
    dpkg --add-architecture i386; \
    DEBIAN_FRONTEND=noninteractive apt-get update -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        apt-transport-https \
        binutils \
        cabextract \
        curl \
        # To take screenshots of Xvfb display
        imagemagick \
        p7zip \
        software-properties-common \
        wget \
        unzip \
        xz-utils 
        # xvfb

RUN set -ex; \
    wget -nc https://dl.winehq.org/wine-builds/winehq.key; \
    apt-key add winehq.key; \
    apt-add-repository https://dl.winehq.org/wine-builds/ubuntu/; \
    DEBIAN_FRONTEND=noninteractive apt-get update -y; \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --install-recommends \
        winehq-stable; \
    rm winehq.key

RUN set -ex; \
    wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks; \
    chmod +x winetricks; \
    mv winetricks /usr/local/bin

COPY waitonprocess.sh run_mt.sh screenshot.sh /docker/
ADD cache $HOME/.cache
ADD cache/fonts $HOME/.wine/drive_c/windows/Fonts
RUN set -ex; \
    chmod a+rx -R /docker/; \
    chown $USER:$USER -R $HOME

USER $USER
RUN set -ex; \
    wine wineboot --init; \
    /docker/waitonprocess.sh wineserver; \
    winetricks --unattended dotnet40; \
    /docker/waitonprocess.sh wineserver
    

#WORKDIR $MT4DIR
WORKDIR $HOME

ENTRYPOINT ["/bin/bash"]
CMD ["/docker/run_mt.sh"]

# @TODO Add ability to list logs which content should be redirected to STDOUT with a prefix
# @TODO Add ability to change TZ of the OS
