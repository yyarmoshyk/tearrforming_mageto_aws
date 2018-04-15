yum install -y gcc libstdc++-devel gcc-c++ curl curl* curl-devel libxml2 libxml2* libxml2-devel openssl-devel mailcap

cd /usr/local/src
wget http://downloads.sourceforge.net/project/fuse/fuse-2.X/2.9.3/fuse-2.9.3.tar.gz
tar -xzf fuse-2.9.3.tar.gz
rm -f fuse-2.9.3.tar.gz
mv fuse-2.9.3 fuse
cd fuse/
./configure –prefix=/usr
make
make install
export PKG_CONFIG_PATH=/usr/lib/pkgconfig:/usr/lib64/pkgconfig/
ldconfig
modprobe fuse
pkg-config –modversion fuse

wget http://s3fs.googlecode.com/files/s3fs-1.74.tar.gz
tar -xzvf s3fs-1.74.tar.gz
rm -f s3fs-1.74.tar.gz
mv s3fs-1.74 s3fs
cd s3fs
./configure –prefix=/usr
make
make install

echo “{{S3_BUCKET}}:{{API_PUBLIC_ACCESS_KEY}}:{{API_SECRET_ACCESS_KEY}}” > ~/.passwd-s3fs
chmod 600 ~/.passwd-s3fs

echo “user_allow_other” > /etc/fuse.conf

echo “s3fs#{{S3_BUCKET}} {{MOUNTED_DIRECTORY}} fuse use_cache=/tmp,allow_other,uid={{UID}},gid={{GID}} 0 0″ >> /etc/fstab

s3fs -o allow_other -o uid={{UID}} -o gid={{GID}} -ouse_cache=/tmp {{S3_BUCKET}} {{MOUNTED_DIRECTORY}}
