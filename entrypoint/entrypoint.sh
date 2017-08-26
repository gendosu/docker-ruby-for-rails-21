#!/bin/bash
# set -eu

# bundle

# rake db:migrate

if [ -e /products/tmp/pids/*.pid ]; then rm /products/tmp/pids/*.pid; fi

exec "$@"
