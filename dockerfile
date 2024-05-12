FROM ubuntu


# *** PACKAGE INSTALLS ***
# install packages before copying in source so we don't do this on every source change
RUN apt-get update && \
  apt-get install -y dos2unix avahi-daemon avahi-autoipd
#
# setup.sh is standalone (IIUC upon cursory inspection) at least for debian/aarch64 + vosk purposes
# setup.sh is more or less further `apt install...` + some file setup (i.e. chipper/source.sh)... thus run this as early as possible as it is not likely to change (as much) as the source code
COPY setup.sh /setup.sh
RUN dos2unix /setup.sh && mkdir /chipper && mkdir /vector-cloud
RUN ["/bin/sh", "-c", "STT=vosk ./setup.sh"]
# *** END PACKAGE INSTALLS ***

# TODO figure out if anything gets clobbered that was created by setup.sh (i.e. ./chipper/source.sh which is created by setup.sh)
COPY . .

# TODO do we really need dos2unix? can't we use editorconfig or something else to enforce line endings? and/or force git checkout to have LF endings always? SAME with setup.sh above too
RUN dos2unix /chipper/start.sh

CMD ["/bin/sh", "-c", "./chipper/start.sh"]