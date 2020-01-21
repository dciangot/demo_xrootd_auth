#!/bin/bash

XRD_VERSION=4.11.1-1.el7

echo "LC_ALL=C" >> /etc/environment \
    && echo "LANGUAGE=C" >> /etc/environment \
    && yum --setopt=tsflags=nodocs -y update \
    && yum --setopt=tsflags=nodocs -y install wget \
    && yum clean all

cd /etc/yum.repos.d
wget http://repository.egi.eu/community/software/preview.repository/2.0/releases/repofiles/centos-7-x86_64.repo \
    && wget http://repository.egi.eu/sw/production/cas/1/current/repo-files/EGI-trustanchors.repo
yum --setopt=tsflags=nodocs -y install epel-release yum-plugin-ovl \
    && yum --setopt=tsflags=nodocs -y install fetch-crl wn sysstat git vim gcc cmake make\
    && yum clean all

yum -y install https://repo.opensciencegrid.org/osg/3.4/osg-3.4-el7-release-latest.rpm

yum install -y ca-policy-egi-core ca-policy-lcg
/usr/sbin/fetch-crl -q

yum install -y xrootd-server-$VERSION xrootd-scitokens xrootd-multiuser xrootd-voms-plugin

systemctl enable fetch-crl-cron
systemctl start fetch-crl-cron

## START Configuration for demo

mkdir -p /etc/grid-security/xrd/

chown -R xrootd:xrootd /etc/grid-security/xrd/

mkdir -p /data/x509/atlas
mkdir -p /data/x509/cms
mkdir -p /data/user/tizio
mkdir -p /data/user/caio
mkdir -p /data/http/votest/
mkdir -p /data/http/votest2/

useradd tizio
useradd caio
useradd votest
useradd votest2

chown -R xrootd:xrootd /data/x509/atlas \
                                   /data/x509/cms \
                                   /data/http

chown -R votest: /data/http/votest/
chown -R votest2: /data/http/votest2/
chmod -R 700 /data/http/votest2/
chmod -R 700 /data/http/votest/

chown -R tizio: /data/user/tizio
chown -R caio: /data/user/caio

for dir in `ls config/`; do
    for file in `ls config/$dir`; do
        cp config/$dir/$file /etc/xrootd/$file
        chown xrootd:xrootd /etc/xrootd/$file
done