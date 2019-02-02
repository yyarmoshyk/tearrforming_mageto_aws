#!/bin/bash
yum remove -y fuse fuse-s3fs

yum install -y gcc libstdc++-devel gcc-c++ curl-devel libxml2-devel openssl-devel mailcap git jq automake

cd /usr/src/
wget https://github.com/libfuse/libfuse/releases/download/fuse-3.0.0/fuse-3.0.0.tar.gz
tar xzf fuse-3.0.0.tar.gz
rm -rf fuse-3.0.0.tar.gz
cd fuse-3.0.0
./configure -prefix=/usr/local
make && make install

export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ldconfig
modprobe fuse

cd /usr/src/
git clone https://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make && make install

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
