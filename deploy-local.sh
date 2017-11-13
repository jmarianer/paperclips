set -e
sh build-local.sh
aws s3 rm --recursive s3://paperclips.joeym.org
aws s3 cp --recursive out s3://paperclips.joeym.org
