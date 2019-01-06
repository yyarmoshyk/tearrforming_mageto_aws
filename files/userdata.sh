#!/bin/#!/usr/bin/env bash

yum install -y gcc libstdc++-devel gcc-c++ curl curl* curl-devel libxml2 libxml2* libxml2-devel openssl-devel mailcap automake make git fuse fuse-devel

git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make
make install

AccessKeyId=$(curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${my_role} | jq -r .AccessKeyId)
SecretAccessKey=$(curl http://169.254.169.254/latest/meta-data/iam/security-credentials/${my_role} | jq -r .SecretAccessKey)

cd ..


echo "$AccessKeyId:$SecretAccessKey" > /etc/passwd-s3fs
chmod 600 /etc/passwd-s3fs

echo "user_allow_other" > /etc/fuse.conf

#echo “s3fs#{{S3_BUCKET}} {{MOUNTED_DIRECTORY}} fuse use_cache=/tmp,allow_other,uid={{UID}},gid={{GID}} 0 0″ >> /etc/fstab
for domain in $(echo ${domains} |sed 's/,/ /g');do
  mkdir -p /srv/$${domain}/www/media
  echo "s3fs#${S3_BUCKET} /srv/$${domain}/www/media fuse use_cache=/tmp,allow_other 0 0" >> /etc/fstab
done

mount -a
