BUCKET_NAME="insert_bucket_name"
LOG_DIR="/var/log/s3"

mkdir -p $LOG_DIR
s3cmd sync s3://$BUCKET_NAME $LOG_DIR

service logentries restart
