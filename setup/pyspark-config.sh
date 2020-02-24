#!/bin/bash
#
# this file can be added as an initial script while creating spark nodes independently
# the script will install all the necessary packages and dependencies to easily integrate 
# a new node into the Spark cluster

# update system
sudo apt-get update -y


# install python3 and aws dependencies
sudo apt-get install python3-pip -y
pip3 install pyspark boto3 warcio


# download spark
curl -O http://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz


# spark runs on java 8, install it and set environment variable
sudo apt install openjdk-8-jdk -y
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64


# if another java version is already installed, it will conflict with java 8.
# do a soft link to overcome this conflict
sudo ln -sf /usr/lib/jvm/java-8-openjdk-amd64/bin/java /usr/bin/java


# spark also uses scala
sudo apt-get install scala -y


# unpack and setup spark
sudo tar -zxvf spark-2.4.0-bin-hadoop2.7.tgz
export SPARK_HOME=/home/ubuntu/spark-2.4.0-bin-hadoop2.7

# edit files spark-env.sh
echo "export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
export DEFAULT_HADOOP_HOME=/home/ubuntu/spark-2.4.0-bin-hadoop2.7
export PYSPARK_PYTHON=/usr/bin/python3
export PYSPARK_DRIVER_PYTHON=python3" | sudo tee -a /home/ubuntu/spark-2.4.0-bin-hadoop2.7/conf/spark-env.sh

# and spark-defaults.sh
echo "spark.executor.extraClassPath /home/ubuntu/spark-2.4.0-bin-hadoop2.7/jars/aws-java-sdk-1.7.4.jar:/home/ubuntu/spark-2.4.0-bin-hadoop2.7/jars/hadoop-aws-2.7.6.jar
spark.driver.extraClassPath /home/ubuntu/spark-2.4.0-bin-hadoop2.7/jars/aws-java-sdk-1.7.4.jar:/home/ubuntu/spark-2.4.0-bin-hadoop2.7/jars/hadoop-aws-2.7.6.jar:/home/ubuntu/spark-2.4.0-bin-hadoop2.7/jars/postgresql-42.2.9.jar" | sudo tee -a /home/ubuntu/spark-2.4.0-bin-hadoop2.7/conf/spark-defaults.sh
