#!/bin/bash

echo "starting test"


DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

"$DIR/../bin/docker-wait" "$DIR/test_config.coffee"

echo "watchover"
