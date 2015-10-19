#!/bin/bash

set -u
set -e

init_hdfs_dir(){
    set +e

    $HADOOP_HOME/bin/hadoop fs -mkdir /tmp
    $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp
    $HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse

    set -e
}

start_services(){
    nohup $HIVE_HOME/bin/hiveserver2 > /tmp/hiveserver2.log 2>&1 &
    nohup $HIVE_HOME/hcatalog/sbin/hcat_server.sh > /tmp/hcat_server.sh.log 2>&1 &

    ps -ax | grep -e hiveserver2 -e hcat_server.sh

    echo "connect the beeline with command: $HIVE_HOME/bin/beeline -u jdbc:hive2://localhost:10000"
}

main(){
  init_hdfs_dir
  start_services
}

main $@
