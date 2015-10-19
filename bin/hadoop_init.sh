#!/bin/bash

set -e
set -u

readonly __hadoop_root_dir="/usr/local/hadoop"
readonly __hdfs_storage_dir="/tmp/hadoop-${USER}"

start_hdfs(){
    # start the namenode
    # The hadoop daemon log output is written to the $HADOOP_LOG_DIR directory (defaults to $HADOOP_HOME/logs).
    # sbin/stop-dfs.sh
    sbin/start-dfs.sh

    # in case namenode is in safe mode
    sleep 10

    echo "Success! HDFS is ready."
}

start_yarn(){
    sbin/start-yarn.sh

    sleep 10

    echo "Success! YARN is ready."
    #  echo "******* be careful, need mannually start the yarn***********"
    #  echo "${HADOOP_HOME}/sbin/start-yarn.sh"
    #  echo "************************************************************"
}

sanity_test(){
    # Browse the web interface for the NameNode; by default it is available at:
    # NameNode - http://localhost:50070/
    if hdfs dfs -test -e /user/${USER} 2>&1 ; then
      bin/hdfs dfs -rmr /user/${USER}
    fi

    bin/hdfs dfs -mkdir -p /user/${USER}

    # Copy the input files into the distributed filesystem
    bin/hdfs dfs -put etc/hadoop /user/${USER}/input

    # Run some of the examples provided
    bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.1.jar grep /user/${USER}/input /user/${USER}/output 'dfs[a-z.]+'

    hdfs dfs -cat /user/${USER}/output/part-r-00000

    echo "Success! Complete sanity test"
}

init(){
    # TODO: need figure out a better solution
    if [[ -d "${__hdfs_storage_dir}" ]]; then
        rm -rf "${__hdfs_storage_dir}"
    fi

    # format the system, be careful
    yes Y | bin/hdfs namenode -format

    sbin/stop-yarn.sh

    sbin/stop-dfs.sh

    echo "Success! Initialization"
}

main(){
    # move to hadoop home directory
    cd "${__hadoop_root_dir}"

    init

    start_hdfs

    start_yarn

    sanity_test

    echo "NameNode: http://localhost:50070/"

    echo "Resource Manager: http://localhost:8088"

    cd -
}

main $@
