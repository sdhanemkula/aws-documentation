# How to run spark history server with Glue
Glue job execution now supports the ability to 'save' the spark events to a location in S3! Using this file we can run the spark history server locally to actually see what spark is doing while the job is running.

Basic outline is:
 * install spark history server locally
 * run glue job with "Monitoring Options" => "Job Metrics" and "Spark UI" enabled. This will prompt for a S3 bucket location to put the final events log file.
 * Once job completes download the events log file from S3 to local directory (see below)
 * Run history server on laptop to analyze jobs' stages, jobs, tasks, etc.

## Install spark locally
```
# install spark 2.4 version
brew install apache-spark (2.4 version)

# installs into cd /usr/local/Cellar/apache-spark/2.4.4/libexec/sbin
```

## Create local directory for events
If you attempt to start the spark history server locally you will get an error for no spark-event directory to read from!

```
# create local directory for events
# file:/tmp/spark-events does not exist
mkdir /tmp/spark-events
```

This directory is where we download all the performance files from S3 locally for analysis.

You can also try and create a spark-defaults.conf file if want to make configuration changes
/usr/local/Cellar/apache-spark/2.4.4/libexec/conf/spark-defaults.conf (configuration file changes)
The default installation only puts a spark-defaults.conf.template file with values commented out.

```
# I think this is the properties to set but I could be wrong!
spark.history.fs.logDirectory
spark.eventLog.dir
````

## Start/Stop history server

```
# To start the historyserver
cd /usr/local/Cellar/apache-spark/2.4.4/libexec
sbin/start-history-server.sh

# To stop the history server
sbin/stop-history-server.sh
```

## URL to find history server

http://localhost:18080/
