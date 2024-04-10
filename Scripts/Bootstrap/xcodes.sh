#!/bin/sh

readonly arguments=$@
readonly script_path="$( cd "$( dirname "$0" )" && pwd )"

source "${script_path}/common.sh"

echo "Checking ${xcode_style}xcodes${default_style} installation:"

brew_install_if_needed xcodesorg/made/xcodes "$arguments"

echo ""
