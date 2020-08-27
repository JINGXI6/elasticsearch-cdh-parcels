#!/bin/sh
# ES CONTROL

# ELASTICSEARCH_HOME=/opt/cloudera/parcels/ELASTICSEARCH-7.9.0/lib/elasticsearch
# "environmentVariables" : {
#				"CURRENT_RULE" : "es-data02"
#				"ES_LOG_DIR" : "${path_data}"
#			}


ES_CONF_DIR=$ELASTICSEARCH_HOME/config/$CURRENT_RULE
PID_FILE=$ES_CONF_DIR/es.pid
RUN_USER=elasticsearch
# customer java
locateJava() {
	echo "SET JAVA_HOME"
    	export JAVA_HOME=$ELASTICSEARCH_HOME/jdk/
    	echo "Changing Java Home to: $JAVA_HOME"
	export JAVA="$JAVA_HOME/bin/java"
	echo "Changing Java to: $JAVA"
    	echo "Changed."
	chown elasticsearch:elasticsearch -R $JAVA_HOME
}

config() {
	echo
	echo "Creating jvm.properties"
	echo
	echo "" > jvm.options
	while IFS= read -r line; do echo ${line#*=} >> jvm.options; done < jvm.properties
	cp -uf jvm.options $ES_CONF_DIR
	
	echo
	#echo "discovery.zen.ping.unicast.hosts"
	#hosts="["
	#while IFS= read -r line; do hosts=$hosts`echo $line | awk -F':' '{print $1}'`", " ; done < nodes.properties
	#hosts="discovery.zen.ping.unicast.hosts: "$hosts"localhost]"
	#echo $hosts
	echo
	
	echo
	echo "Creating elasticsearch.yml"
	echo
	echo "" > elasticsearch.yml
	while IFS= read -r line; do echo ${line%=*}": "${line#*=} >> elasticsearch.yml ; done < elasticsearch.properties
	#echo $hosts >> elasticsearch.yml
	cp -uf elasticsearch.yml $ES_CONF_DIR
	chown elasticsearch:elasticsearch -R $ES_CONF_DIR
	
}

init() {
	if [ ! -d $ES_LOG_DIR ];
	then
		mkdir $ES_LOG_DIR
	fi
	if [ ! -d $ES_DATA_DIR ];
	then
		mkdir $ES_DATA_DIR
	fi
	chown elasticsearch:elasticsearch -R $ES_LOG_DIR
	chown elasticsearch:elasticsearch -R $ES_DATA_DIR
	chmod 755 $ES_LOG_DIR
	chmod 755 $ES_DATA_DIR
	
	ulimit -n 65536
	ulimit -u 4096
	sysctl -w vm.max_map_count=262144
	sysctl -w net.ipv4.tcp_retries2=5
	# Locate the Java VM to execute
	locateJava
	config
}

start() {
	echo "Running Elastic Search Node"
    	exec runuser -l $RUN_USER -c "cd $ELASTICSEARCH_HOME/bin/ && export ES_PATH_CONF=$ES_CONF_DIR && JAVA_HOME=$JAVA_HOME && ./elasticsearch -p $PID_FILE"
}

stop() {
    kill -15  `cat $PID_FILE`
}


init
case "$1" in
    start)
        start
        ;;
	stop)
		stop
		;;
    restart)
        start
		stop
		;;
    *)
        echo "Usage Elastic Search {start|stop|restart}"
        ;;
esac
