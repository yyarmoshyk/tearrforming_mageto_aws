## Mount s3 buckets into media folders
## Using the IAM role attached to instance
apt-get update
apt-get install -y docker git jq s3fs python-pip curl docker-compose

myrole=$(curl http://169.254.169.254/latest/meta-data/iam/security-credentials/)

s3fs ${S3_BUCKET} ~/s3-drive -oiam_role=$myrole

for domain in $(echo ${domains} |sed 's/,/ /g');do
  mkdir -p /srv/$${domain}/www/media
  #Create keys in s3 bucket
  aws s3api put-object --bucket ${S3_BUCKET} --key $${domain}/www/media/
  echo "s3fs#${S3_BUCKET}/$${domain}/www/media/ /srv/$${domain}/www/media fuse use_cache=/tmp,allow_other,iam_role=$myrole 0 0" >> /etc/fstab
done

mount -a
