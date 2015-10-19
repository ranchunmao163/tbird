#!/bin/bash

init_hdfs_dir(){
  $HADOOP_HOME/bin/hadoop fs -mkdir /tmp
  $HADOOP_HOME/bin/hadoop fs -mkdir -p /user/hive/warehouse
  $HADOOP_HOME/bin/hadoop fs -chmod g+w /tmp
  $HADOOP_HOME/bin/hadoop fs -chmod g+w /user/hive/warehouse
}

main(){
  init_hdfs_dir
}

main $@
