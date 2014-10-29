#!/bin/bash
set -e

LAZYBONES_VERSION="0.7.1"
SELENIUM_VERSION="2.42.2"
SELENIUM_FOLDER=${SELENIUM_VERSION%.*}

function setup {
	sudo sudo apt-get purge openjdk*
	unset JAVA_HOME	
	sudo rm /usr/bin/phantomjs
}

function install_java {
	sudo apt-get -q -y install python-software-properties
	sudo add-apt-repository -y ppa:webupd8team/java > /dev/null
	sudo apt-get -q -y update
	echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections
	echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 seen true" | sudo debconf-set-selections

	sudo apt-get -q -y install oracle-java8-set-default
}

function install_lazybones {
	curl -s get.gvmtool.net | bash
	echo "gvm_auto_answer=true" > ~/.gvm/etc/config
	source ~/.gvm/bin/gvm-init.sh
	gvm install lazybones
	gvm use lazybones
}

function start_selenium {
	sudo start xvfb
	wget "http://selenium-release.storage.googleapis.com/$SELENIUM_FOLDER/selenium-server-standalone-$SELENIUM_VERSION.jar" --quiet
	java -jar "selenium-server-standalone.$SELENIUM_VERSION.jar" > /dev/null 2>&1 &
}

setup
install_java
install_lazybones
start_selenium

printf "Testing Angular 1.2...\n"
./gradlew buildTestApp -PangularVersion=1.2
cd test/app
./gradlew test -PgrailsArgs=geb.waiting.timeout=60
printf "Done testing Angular 1.2!\n"

printf "Testing Angular 1.3...\n"
cd ../../
./gradlew buildTestApp -PangularVersion=1.3
cd test/app
./gradlew test -PgrailsArgs=geb.waiting.timeout=60
printf "Done testing Angular 1.3!\n"

#Build
./gradlew war