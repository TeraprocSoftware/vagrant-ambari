#!/bin/bash

#java
JAVA_ARCHIVE=jdk-7u51-linux-x64.gz
#ant
ANT_ARCHIVE=apache-ant-1.9.4-bin.zip
#maven
MAVEN_ARCHIVE=apache-maven-3.2.5-bin.zip

function resourceExists {
	FILE=/vagrant/resources/$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

function fileExists {
	FILE=$1
	if [ -e $FILE ]
	then
		return 0
	else
		return 1
	fi
}

#echo "common loaded"
