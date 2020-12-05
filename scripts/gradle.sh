#!/usr/bin/env bash
# cd into the directory where this script is located
cd "${BASH_SOURCE%/*}/" || exit

# TODO: Error handling throughout

function detect_os() {
  linux=false
  darwin=false

  local uname_value
  uname_value=$(uname)
  case "${uname_value}" in
    Linux* )
      echo "Linux detected"
      linux=true
      ;;
    Darwin* )
      echo "Mac OS detected"
      darwin=true
      ;;
    * )
      echo "!!!! Unsupported OS: ${uname_value} !!!!"
      echo "Falling back to Linux, but it's unlikely to work..."
      linux=true
      ;;
  esac
}

function install_jdk() {
  echo "This may take several minutes depending on your internet connection..."
  echo

  local sdk_filename
  if [[ "${linux}" == "true" ]]; then
    sdk_filename="OpenJDK15U-jdk_x64_linux_hotspot_15.0.1_9.tar.gz"
  elif [[ "${darwin}" == "true" ]]; then
    sdk_filename="OpenJDK15U-jdk_x64_mac_hotspot_15.0.1_9.tar.gz"
  else
    echo "ERROR: Invalid OS detected"
    exit 1
  fi

  local sdk_url
  sdk_url="https://github.com/AdoptOpenJDK/openjdk15-binaries/releases/download/jdk-15.0.1%2B9/${sdk_filename}"

  local tmp_dir
  # 1st one is for Linux & Mac OS >=10.11, 2nd for Mac OS <10.11
  tmp_dir=$(mktemp -d 2>/dev/null || mktemp -d -t 'jdk_download')
  trap 'rm -rf "$tmp_dir"' EXIT
  echo "Temp dir: ${tmp_dir}"

  local downloaded_jdk_path
  downloaded_jdk_path="${tmp_dir}/${sdk_filename}"

  echo "Downloading ${sdk_url}"
  curl -L --output "${downloaded_jdk_path}" ${sdk_url}
  echo "Done"

  echo "Extracting ${sdk_filename}"
  mkdir -p "${GRADLE_USER_HOME}/jdks"
  tar -xf "${downloaded_jdk_path}" --directory "${GRADLE_USER_HOME}/jdks"
  echo "Done"

  rm -rf "${tmp_dir}"
}

function main() {
  detect_os

  if [ ! -f "${JAVA_HOME}/bin/javac" ]; then
    # echo "No JDK found in JAVA_HOME"

    # Provide a value for GRADLE_USER_HOME if not set
    : ${GRADLE_USER_HOME:="${HOME}/.gradle"}


    if [[ "${linux}" == "true" ]]; then
      JAVA_HOME="${GRADLE_USER_HOME}/jdks/jdk-15.0.1+9"
    elif [[ "${darwin}" == "true" ]]; then
      JAVA_HOME="${GRADLE_USER_HOME}/jdks/jdk-15.0.1+9/Contents/Home"
    else
      echo "ERROR: Invalid OS detected"
      exit 1
    fi

    if [ ! -f "${JAVA_HOME}/bin/javac" ]; then
      # echo "No JDK found in ${GRADLE_USER_HOME}"

      install_jdk
    fi
  fi

  cd ../app
  JAVA_HOME=${JAVA_HOME} ./gradlew "$@"
}

main "$@"
