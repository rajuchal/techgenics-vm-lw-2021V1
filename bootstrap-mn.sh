#!/usr/bin/env bash
# Update the index
sudo apt-get -y update

# Install c libraries 
sudo apt-get -y install build-essential
# Install vi editor
sudo apt-get -y install vim
sudo apt-get -y install tree
sudo apt-get -y install net-tools
sudo apt-get -y install sshpass
sudo apt-get -y install unzip
sudo apt-get -y install curl

#Installing Python 3.7
sudo apt -y install software-properties-common
sudo add-apt-repository -y ppa:deadsnakes/ppa
sudo apt -y update
sudo apt -y install python3.7
echo " Python 3.7 installation complete "

#Adding Open JDK installer
sudo -E add-apt-repository -y ppa:openjdk-r/ppa
sudo apt-get -y update
sudo apt-get -y install openjdk-8-jdk
sudo update-ca-certificates -f

#sudo apt-get install lxde
#sudo apt-get install gedit


# Setup SSH
ssh-keygen -t rsa -P "" -f /home/vagrant/.ssh/id_rsa
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/known_hosts
curl https://raw.githubusercontent.com/mitchellh/vagrant/master/keys/vagrant.pub >>/home/vagrant/.ssh/authorized_keys

chmod 0600 /home/vagrant/.ssh/authorized_keys

# Verify ssh

ssh -o StrictHostKeyChecking=no vagrant@localhost 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no vagrant@master 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no vagrant@192.168.56.70 'sleep 5 && exit'
ssh -o StrictHostKeyChecking=no vagrant@0.0.0.0 'sleep 5 && exit'


echo "Installing MySQL Server"
echo "mysql-server mysql-server/root_password password root" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" | sudo debconf-set-selections
sudo apt-get -y install mysql-server mysql-client
echo " MySQL server  installed"

mysql -uroot -proot -e "CREATE DATABASE metastore_db;"
    mysql -uroot -proot -e "CREATE USER 'hiveuser'@'localhost' IDENTIFIED BY 'hivepassword';"
	mysql -uroot -proot -e "CREATE USER 'hiveuser'@'master' IDENTIFIED BY 'hivepassword';"
    mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'localhost' identified by 'hivepassword';"
	mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'master' identified by 'hivepassword';"
	mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'hiveuser'@'%' identified by 'hivepassword';"
	mysql -uroot -proot -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' identified by 'root';"
    mysql -uroot -proot -e "FLUSH PRIVILEGES;"
echo " metastore_db @MySQL server  created"

#Host Name - IP Address resolution
cp /vagrant/hosts /home/vagrant
sudo chmod 777 /etc/hosts
cat /home/vagrant/hosts >/etc/hosts
sudo chmod 644 /etc/hosts


# Create directory to store the MongoDB document
sudo mkdir -p /data/db
sudo chown -R vagrant:vagrant /data

# Create directory to store the required software
mkdir -p /home/vagrant/bigdata
cd /home/vagrant/bigdata
pwd

# Create directories for name node and data node
mkdir -p /home/vagrant/bigdata/hadoop_tmp/hdfs/namenode
mkdir -p /home/vagrant/bigdata/hadoop_tmp/hdfs/datanode

# Create directories for spark-events
mkdir -p /home/vagrant/bigdata/spark-events
mkdir -p /home/vagrant/bigdata/spark_tmp/spark


mkdir -p /home/vagrant/bigdata/hive_tmp/hive
mkdir -p /home/vagrant/bigdata/zookeeper


#---------------- Hadoop Stack Software -------------------------------------------------
# Download hadoop binaries
echo "Dowloading Hadoop"
wget  -q https://downloads.apache.org/hadoop/common/stable2/hadoop-2.10.1.tar.gz

# Download Hive binaries
echo "Dowloading Hive"
#wget -q https://mirrors.estointernet.in/apache/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz
wget -q https://downloads.apache.org/hive/hive-2.3.9/apache-hive-2.3.9-bin.tar.gz


# Download Pig binaries
echo "Dowloading Pig"
wget -q https://downloads.apache.org/pig/pig-0.16.0/pig-0.16.0.tar.gz

# Download Sqoop
echo "Dowloading Sqoop"
wget -q http://archive.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz


# Download HBase
echo "Dowloading HBase"
wget -q https://downloads.apache.org/hbase/1.7.1/hbase-1.7.1-bin.tar.gz


#---------------- Hadoop Stack Software End -------------------------------------------------

# Download Spark pre-built with hadoop 2.7+
echo "Dowloading Spark"

wget -q https://archive.apache.org/dist/spark/spark-3.0.2/spark-3.0.2-bin-hadoop2.7.tgz

echo "Dowloading SBT"
wget -q https://github.com/sbt/sbt/releases/download/v1.2.0/sbt-1.2.0.tgz



# Download jdk binaries
echo "Dowloading Java"
wget -q --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz

# Download Scala binaries
echo "Dowloading Scala"
wget -q  https://downloads.lightbend.com/scala/2.12.2/scala-2.12.2.tgz



# Download Kafka binaries
echo "Dowloading Kafka"
wget -q https://archive.apache.org/dist/kafka/2.8.0/kafka_2.12-2.8.0.tgz


# Download Apache Cassandra
echo "Dowloading Cassandra"
wget -q http://archive.apache.org/dist/cassandra/3.11.10/apache-cassandra-3.11.10-bin.tar.gz

# Download MongoDB
echo "Dowloading MongoDB"
#wget -q https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-4.0.9.tgz
wget -q https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz

# Download MySQL JDBC Driver
echo "Dowloading MySQL JDBC Driver"
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz

# Download Confluent Community Edition
echo "Dowloading Confluent Community Edition 6.2.0 "
wget -q https://packages.confluent.io/archive/6.2/confluent-community-6.2.0.tar.gz

#=================================================================================================
echo "Hadoop Extraction Started "
# Extract hadoop binaries
tar -xf hadoop-2.10.1.tar.gz
mv hadoop-2.10.1 hadoop
rm hadoop-2.10.1.tar.gz
echo "Hadoop Extraction Completed "

echo "Hive Extraction Started "
# Extract Hive binaries
tar -xf apache-hive-2.3.9-bin.tar.gz
mv apache-hive-2.3.9-bin hive
rm  apache-hive-2.3.9-bin.tar.gz
echo "Hive Extraction Completed "

echo "Pig Extraction Started "
# Extract Pig binaries
tar -xf pig-0.16.0.tar.gz
mv pig-0.16.0 pig
rm pig-0.16.0.tar.gz
echo "Pig Extraction Completed "

echo "Sqoop Extraction Started "
#Extract Sqoop 
tar xf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
mv sqoop-1.4.7.bin__hadoop-2.6.0 sqoop
rm sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz
echo "Sqoop Extraction Completed "

#Extract HBase 
echo "HBase Extraction Started "
tar -xf hbase-1.7.1-bin.tar.gz 
mv hbase-1.7.1 hbase
rm hbase-1.7.1-bin.tar.gz
#rm /home/vagrant/bigdata/hbase/lib/slf4j-log4j12-1.7.25.jar 
echo "HBase Extraction Completed "

#===============================================================================================
echo "Spark Extraction Started "
# Extract the Spark  binaries
tar -xf spark-3.0.2-bin-hadoop2.7.tgz
mv spark-3.0.2-bin-hadoop2.7 spark
rm spark-3.0.2-bin-hadoop2.7.tgz
echo "Spark Extraction Completed "

echo "Java Extraction Started "
# Extract java binaries
tar -xf jdk-8u131-linux-x64.tar.gz
mv jdk1.8.0_131 java
rm jdk-8u131-linux-x64.tar.gz
echo "Java Extraction Completed "


echo "Scala Extraction Started "
# Extract Scala binaries
 tar -xf scala-2.12.2.tgz
 mv scala-2.12.2 scala
 rm scala-2.12.2.tgz
echo "Scala Extraction Completed "

echo "SBT Extraction Started "
#Extract sbt 
tar -xf sbt-1.2.0.tgz
rm  sbt-1.2.0.tgz
echo "SBT Extraction Completed "

echo "Kafka Extraction Started "
#Extract Kafka 

tar xf kafka_2.12-2.8.0.tgz
mv kafka_2.12-2.8.0 kafka
rm kafka_2.12-2.8.0.tgz
echo "Kafka Extraction Completed "

echo "Cassandra Extraction Started "
#Extract Cassandra 

tar xf apache-cassandra-3.11.10-bin.tar.gz
mv apache-cassandra-3.11.10 cassandra
rm apache-cassandra-3.11.10-bin.tar.gz
echo "Cassandra Extraction Completed "

echo "MongoDB Extraction Started "
#Extract MongoDB 
#tar xf mongodb-linux-x86_64-4.0.9.tgz
#mv mongodb-linux-x86_64-4.0.9 mongodb
#rm mongodb-linux-x86_64-4.0.9.tgz

tar xf mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz
mv mongodb-linux-x86_64-ubuntu1604-4.2.13 mongodb
rm mongodb-linux-x86_64-ubuntu1604-4.2.13.tgz

echo "MongoDB Extraction Completed "

echo "MySQL JDBC Extraction Started "
#Extract MySQL JDBC Driver 
tar xf mysql-connector-java-5.1.47.tar.gz
mv mysql-connector-java-5.1.47 mysql-connector
rm mysql-connector-java-5.1.47.tar.gz
echo "MySQL JDBC Extraction Completed "

echo "Confluent Community Edition Extraction Started "
tar xf confluent-community-6.2.0.tar.gz
mv confluent-6.2.0 confluent
rm confluent-community-6.2.0.tar.gz
echo "Confluent Community Edition Extraction Completed "

echo "Downloading & Installing Confluent Hub "
cd /home/vagrant/bigdata/confluent/
wget -q http://client.hub.confluent.io/confluent-hub-client-latest.tar.gz
tar xf confluent-hub-client-latest.tar.gz
rm confluent-hub-client-latest.tar.gz
cd /home/vagrant/bigdata/
echo "Download & Installation of Confluent Hub completed"

echo "Downloading & Installing Confluent CLI "
# curl -L --http1.1 https://cnfl.io/cli | sh -s -- -b $CONFLUENT_HOME/bin
cd /home/vagrant/
wget -q https://s3-us-west-2.amazonaws.com/confluent.cloud/confluent-cli/archives/latest/confluent_latest_linux_amd64.tar.gz
tar xf confluent_latest_linux_amd64.tar.gz
mv /home/vagrant/confluent/* /home/vagrant/bigdata/confluent/bin/
rm confluent_latest_linux_amd64.tar.gz
cd /home/vagrant/bigdata/
echo "Download & Installation of Confluent CLI completed"


echo " Configuring ENVIRONMENT Variables "
# set env variables in .bashrc file
echo 'export JAVA_HOME=/home/vagrant/bigdata/java' >> /home/vagrant/.bashrc
echo 'export HADOOP_HOME=/home/vagrant/bigdata/hadoop' >> /home/vagrant/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin' >> /home/vagrant/.bashrc
echo 'export HIVE_HOME=/home/vagrant/bigdata/hive' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$HIVE_HOME/bin' >> /home/vagrant/.bashrc
echo 'export PIG_HOME=/home/vagrant/bigdata/pig' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$PIG_HOME/bin' >> /home/vagrant/.bashrc
echo 'export SQOOP_HOME=/home/vagrant/bigdata/sqoop' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SQOOP_HOME/bin' >> /home/vagrant/.bashrc

# set env variables for Hbase
echo 'export HBASE_HOME=/home/vagrant/bigdata/hbase'>> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$HBASE_HOME/bin'>>/home/vagrant/.bashrc

echo 'export SCALA_HOME=/home/vagrant/bigdata/scala' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SCALA_HOME/bin' >> /home/vagrant/.bashrc
echo 'export SPARK_HOME=/home/vagrant/bigdata/spark' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin' >> /home/vagrant/.bashrc
echo 'export SBT_HOME=/home/vagrant/bigdata/sbt' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$SBT_HOME/bin' >> /home/vagrant/.bashrc

echo 'export KAFKA_HOME=/home/vagrant/bigdata/kafka' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$KAFKA_HOME/bin' >> /home/vagrant/.bashrc

echo 'export CASSANDRA_HOME=/home/vagrant/bigdata/cassandra' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$CASSANDRA_HOME/bin' >> /home/vagrant/.bashrc

echo 'export MONGODB_HOME=/home/vagrant/bigdata/mongodb' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$MONGODB_HOME/bin' >> /home/vagrant/.bashrc

echo 'export CONFLUENT_HOME=/home/vagrant/bigdata/confluent' >> /home/vagrant/.bashrc
echo 'export PATH=$PATH:$CONFLUENT_HOME/bin' >> /home/vagrant/.bashrc

echo 'export PYSPARK_PYTHON=python3.7'>>/home/vagrant/.bashrc

source /home/vagrant/.bashrc
source /home/vagrant/.bashrc
echo $JAVA_HOME

echo " Configuring ENVIRONMENT Variables Completed"

echo " Copying Configuration Files "
# Add JAVA_HOME in hadoop-env.sh
echo 'export JAVA_HOME=/home/vagrant/bigdata/java' >> /home/vagrant/bigdata/hadoop/etc/hadoop/hadoop-env.sh

# copy hadoop configuraton files from host to the guest VM
#By default, Vagrant will share your project directory (the directory with the Vagrantfile) to /vagrant

cp /vagrant/core-site.xml /home/vagrant/bigdata/hadoop/etc/hadoop/
cp /vagrant/hdfs-site.xml /home/vagrant/bigdata/hadoop/etc/hadoop/
cp /vagrant/mapred-site.xml /home/vagrant/bigdata/hadoop/etc/hadoop/
cp /vagrant/yarn-site.xml /home/vagrant/bigdata/hadoop/etc/hadoop/
cp /vagrant/masters /home/vagrant/bigdata/hadoop/etc/hadoop/
cp /vagrant/slaves /home/vagrant/bigdata/hadoop/etc/hadoop/

cp /vagrant/hive-site.xml /home/vagrant/bigdata/hive/conf/
cp /vagrant/hive-env.sh /home/vagrant/bigdata/hive/conf/
cp /vagrant/hive-config.sh /home/vagrant/bigdata/hive/bin/

# copy Spark configuraton files from host to the guest VM
cp /vagrant/slaves /home/vagrant/bigdata/spark/conf/
cp /vagrant/spark-env.sh /home/vagrant/bigdata/spark/conf/
cp /vagrant/spark-defaults.conf /home/vagrant/bigdata/spark/conf/
cp /vagrant/log4j.properties /home/vagrant/bigdata/spark/conf/
#cp /vagrant/hive-site.xml /home/vagrant/bigdata/spark/conf/

# copy Hive configuraton file into Sqoop conf directory
cp /vagrant/hive-site.xml /home/vagrant/bigdata/sqoop/conf/
 
#HBase related configuration file
cp  /vagrant/hbase-site.xml /home/vagrant/bigdata/hbase/conf/
cp  /vagrant/hbase-env.sh /home/vagrant/bigdata/hbase/conf/

# copy regionservers file from host to the guest VM  
#cp /vagrant/config/hbase/regionservers /home/vagrant/bigdata/hbase/conf/
echo 'master' >/home/vagrant/bigdata/hbase/conf/regionservers
 
#Copy  MySQL JDBC Driver to Hive Directory
echo " Configuring JDBC Driver for Hive, Spark & Kafka "
cp /home/vagrant/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar /home/vagrant/bigdata/hive/lib/
cp /home/vagrant/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar /home/vagrant/bigdata/sqoop/lib/
cp /home/vagrant/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar /home/vagrant/bigdata/spark/jars/
cp /home/vagrant/bigdata/mysql-connector/mysql-connector-java-5.1.47.jar /home/vagrant/bigdata/kafka/libs/
echo " Configuring JDBC Driver for Hive, Spark & Kafka Completed"

echo " Configuring JDBC Driver for Confluent "
mkdir -p /home/vagrant/bigdata/confluent/share/java/kafka-connect-jdbc
cp /home/vagrant/bigdata/mysql-connector/*.jar /home/vagrant/bigdata/confluent/share/java/kafka-connect-jdbc/
wget -q https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.25.tar.gz
tar xf mysql-connector-java-8.0.25.tar.gz
cp mysql-connector-java-8.0.25/*.jar /home/vagrant/bigdata/confluent/share/java/kafka-connect-jdbc/
echo " Configuring JDBC Driver for Confluent complete"


sudo cp /vagrant/my.cnf /etc/mysql/my.cnf	

# copy dataset files from host to the guest VM   
cp  /vagrant/dataset.zip /home/vagrant/dataset.zip
cp  /vagrant/install-connectors.sh /home/vagrant/install-connectors.sh

echo " Copying Configuration Files Completed"

echo " Installing Confluent Kafka Connector "
echo " Installing Confluent Kafka Datagen Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:latest
echo " Installation Completed of  Confluent Kafka Datagen Connector "

echo " Installing Confluent Kafka JDBC Source/Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
echo " Installation Completed of  JDBC Source/Sink Connector "

echo " Installing Confluent Kafka HDFS3 Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs3:1.1.1
echo " Installation Completed of  HDFS3 Sink Connector "

echo " Installing Confluent Kafka Debezium Source Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.5.0
echo " Installation Completed of  Debezium Source Connector "

echo " Installing Confluent Kafka Cassandra Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:2.0.0
echo " Installation Completed of  Cassandra Sink Connector "

echo " Installing Confluent Kafka MongoDB Source/Sink Connector "
/home/vagrant/bigdata/confluent/bin/confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:1.5.1
echo " Installation Completed of  MongoDB Source/Sink Connector "
echo " Installing Confluent Kafka Connector Completed"

echo " Formatting NameNode "
# Format namenode
/home/vagrant/bigdata/hadoop/bin/hadoop namenode -format

echo " Starting HDFS Services "
# Start dfs
/home/vagrant/bigdata/hadoop/sbin/start-dfs.sh
#Check if namenode, datanode and secondary namenode has started
/home/vagrant/bigdata/java/bin/jps

echo " Starting YARN Services "
# Start yarn
/home/vagrant/bigdata/hadoop/sbin/start-yarn.sh
#Check if resource manager & node manager has started
/home/vagrant/bigdata/java/bin/jps

# Initialize MySQL for Hive 2
echo "Creating Metastore db for Hive "
/home/vagrant/bigdata/hive/bin/hive --service schemaTool -dbType mysql -initSchema
echo "Metastore db creation for Hive completed "

echo " Starting Spark Services "
# Start Spark Master
/home/vagrant/bigdata/spark/sbin/start-master.sh
# Start Spark Slaves
/home/vagrant/bigdata/spark/sbin/start-slaves.sh

#Check if Hadoop Services and Spark Services started 
/home/vagrant/bigdata/java/bin/jps


echo " ###### Running sample WordCount Mapreduce Program ##### "
# Create a input directory in HDFS
/home/vagrant/bigdata/hadoop/bin/hdfs dfs -mkdir -p /user/vagrant/wordcount/input

# Copy a local file to the input directory
/home/vagrant/bigdata/hadoop/bin/hdfs dfs -copyFromLocal /home/vagrant/bigdata/hadoop/README.txt /user/vagrant/wordcount/input/

# Verify that the file has been copied
/home/vagrant/bigdata/hadoop/bin/hdfs dfs -cat /user/vagrant/wordcount/input/README.txt

# Run the wordcount example bundled with the hadoop binaries
/home/vagrant/bigdata/hadoop/bin/hadoop jar /home/vagrant/bigdata/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.10.1.jar wordcount wordcount/input wordcount/output

# Verify the output
/home/vagrant/bigdata/hadoop/bin/hdfs dfs -cat /user/vagrant/wordcount/output/part*
echo " ###### Running sample WordCount Mapreduce Program Completed##### "
#Execute a Spark Example
echo "------------RUNNING SPARK EXAMPLE ------------------------------"
/home/vagrant/bigdata/spark/bin/run-example SparkPi 10

# Check whether the Spark shell is running in local mode
#/home/vagrant/bigdata/spark/bin/spark-shell --master local[*]

# Run Spark shell is running in YARN mode
# /home/vagrant/bigdata/spark/bin/spark-shell --master spark://master:7077
echo "------------RUNNING SPARK EXAMPLE COMPLETED------------------------------"
echo " Stoping Spark Services "

# Stop Spark Slaves
/home/vagrant/bigdata/spark/sbin/stop-slaves.sh
# Stop Spark Master
/home/vagrant/bigdata/spark/sbin/stop-master.sh

echo " Starting Confluent Services "
set CONFLUENT_HOME=/home/vagrant/bigdata/confluent;/home/vagrant/bigdata/confluent/bin/confluent local services start

#Check if all confluent Services started 
/home/vagrant/bigdata/java/bin/jps

echo " Stoping Confluent Services "
set CONFLUENT_HOME=/home/vagrant/bigdata/confluent;/home/vagrant/bigdata/confluent/bin/confluent local services stop
echo "------------PROCESS CURRENTLY RUNNING------------------------------"
/home/vagrant/bigdata/java/bin/jps
echo " Your environment is ready"
