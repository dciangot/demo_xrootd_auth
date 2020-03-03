#!/bin/bash

XRD_VERSION=4.11.2

echo "LC_ALL=C" >> /etc/environment \
    && echo "LANGUAGE=C" >> /etc/environment \
    && yum --setopt=tsflags=nodocs -y update \
    && yum --setopt=tsflags=nodocs -y install wget \
    && yum clean all

cd /etc/yum.repos.d
wget http://repository.egi.eu/community/software/preview.repository/2.0/releases/repofiles/centos-7-x86_64.repo \
    && wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo
yum --setopt=tsflags=nodocs -y install epel-release yum-plugin-ovl \
    && yum --setopt=tsflags=nodocs -y install fetch-crl wn sysstat git vim gcc cmake make ca-policy-egi-core ca-policy-lcg \
             voms-clients-cpp voms \
    && yum clean all

yum install -y xrootd-server-$XRD_VERSION xrootd-devel-$XRD_VERSION gcc-c++

cd $HOME

git clone https://github.com/gganis/vomsxrd.git
cd vomsxrd
git checkout v0.8.0-rc1
mkdir -p build && cd build
cmake .. -DXROOTD_LIBRARY=/lib64 -DCMAKE_INSTALL_PREFIX=/
make install
cd ../.. rm -r vomsxrd
mkdir -p /etc/vomses
wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.vomses -O /etc/vomses/voms-escape.cloud.cnaf.infn.it.vomses
mkdir -p /etc/grid-security/vomsdir/escape
wget https://indigo-iam.github.io/escape-docs/voms-config/voms-escape.cloud.cnaf.infn.it.lsc -O /etc/grid-security/vomsdir/escape/voms-escape.cloud.cnaf.infn.it.lsc

wget https://raw.githubusercontent.com/dciangot/demo_xrootd_auth/master/config/xrootd-escape/xrootd-escape.cfg -O /etc/xrootd/xrootd-escape.cfg