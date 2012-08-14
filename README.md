Option A: Mount the S3 bucket on an EC2 instance
================================================
(recommended)

1. Launch an EC2 instance and create an S3 bucket. In the S3 buckets you wish to gather access logs from, enable Logging (Properties > Logging) and select the new bucket as the Target Bucket. Enter a unique Target Prefix for each, as this will be used to create log files in your Logentries dashboard. Note that the name of the logging bucket must not use upper case characters to comply with the mounting procedure.

2. SSH into the EC2 instance and install the Logentries agent using the appropriate instructions for the operating system from logentries.com/getsetup. Register the machine by running le register.

3. Download le_s3_mount.sh and edit the following variables at the top of the file:
  - AWS Access Key
	- AWS Secret Key
	- Logging Bucket name
	- Logentries User-key (from logentries.com > Account page)
	- (Optionally) S3 mount folder: default = "/var/log/s3"

4. Run the altered script: bash le_s3_mount.sh. It will install [s3fs] (http://code.google.com/p/s3fs/), which is used to mount the bucket in the EC2 instance.

5. For each of the target prefixes given to logged buckets, run le follow 'prefix*'. The asterix ensures that events from the latest timestamped log file are sent to the same log on Logentries.


Advantages
----------
- not dependent on local machine and network.
- logs are uploaded to Logentries in near real-time.
- logs are also accessible in a file system-like structure from EC2.

Disadvantages
-------------
- EC2 downtime results in delays sending logs.
- Requires setup and payment of an EC2 instance.


Option B. Download and forward logs
===================================

This method involves downloading S3 bucket access logs using a cron job and forwarding them on to a Logentries account. As a result, it is not ideal for systems producing a large amount of logs, or for situations where the logs are required in near real time.

1. Launch an EC2 instance and create an S3 bucket. In the S3 buckets you wish to gather access logs from, enable Logging (Properties > Logging) and select the new bucket as the Target Bucket. Enter a unique Target Prefix for each, as this will be used to create log files in your Logentries dashboard.

2. Install the Logentries agent on the machine (local or server) you will download logs to: instructions are at logentries.com/getsetup. Register the host using le register.

3. Install and configure s3cmd, to syncs the log files between your S3 account and your local computer. This can be installed using apt-get install s3cmd, or download from http://s3tools.org/download.
Configure s3cmd with s3cmd --configure. When prompted, enter your AWS Access and Secret Keys.

4. Download le_s3_download.sh and insert the name of your logging bucket in the BUCKET_NAME variable. You may optionally change the download folder location - default is /var/log/s3. 
Run the altered script using a cron job: edit your list of jobs with crontab -e and set it up to run the Logentries script as often as you wish: e.g. to run it every hour - @hourly /path/to/script
This will download the logs from the bucket, which will then be sent on by the Logentries daemon.

5. For each of the target prefixes given to logged buckets, run le follow 'prefix*'. The asterix ensures that events from the latest timestamped log file are sent to the same log on Logentries.

Advantages
----------
- local copy of logs for preprocessing before sending to Logentries.

Disadvantages
-------------
- High frequency logging can require large amounts of free disk space.
- Log events are not displayed in the Logentries UI or alerts in real time.