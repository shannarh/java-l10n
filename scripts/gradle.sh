#!/usr/bin/bash
# cd into the directory where this script is located
cd "${BASH_SOURCE%/*}/" || exit

JAVA_HOME="$HOME/.gradle/jdks/jdk-15.0.1+9"

if [ ! -f "$JAVA_HOME/bin/java" ]
then
  echo "TODO: Install AdoptOpenJdk into JAVA_HOME"
fi

cd ../app
JAVA_HOME=$JAVA_HOME ./gradlew $1
