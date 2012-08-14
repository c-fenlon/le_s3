ACCESS_KEY="insert_access_key"
SECRET_KEY="insert_secret_key"
BUCKET="insert_bucket_name"
LE_USERKEY="insert_le_userkey"
MNT_PATH="/var/log/s3" # Desired path to bucket mount location

# Download and install s3fs
wget "http://s3fs.googlecode.com/files/s3fs-1.61.tar.gz"
tar zxf "s3fs-1.61.tar.gz"
cd "s3fs-1.61"
apt-get update
apt-get install build-essential libxml2-dev libfuse-dev libcurl4-openssl-dev
./configure --prefix=/usr
make
sudo make install

# Configure s3fs for your AWS account and bucket
sudo mkdir -p $MNT_PATH
touch /etc/passwd-s3fs && chmod 640 /etc/passwd-s3fs && echo "$ACCESS_KEY:$SECRET_KEY" > /etc/passwd-s3fs
/usr/bin/s3fs $BUCKET $MNT_PATH

service logentries start
