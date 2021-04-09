#! /bin/bash

if [[ $# -lt 1 ]]; then
	echo usage: run-exomiser.sh input.yml
	exit 1
fi
YAML=$1


JAR=/Users/mkumar1/wdl/tar_example/exomiser-cli-12.1.0/exomiser-cli-12.1.0.jar
PROPS=/Users/mkumar1/wdl/tar_example/b38.application.properties

#JAVA=/software/java/java8/bin/java
JAVA=java

$JAVA -Xms8g -Xmx32g -jar $JAR --analysis $YAML --spring.config.location=$PROPS
