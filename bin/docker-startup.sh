#!/bin/bash

rm -f tmp/pids/server.pid
bundle install -j3 --quiet --path vendor/bundle
rails server -p 8000 -b 0.0.0.0
