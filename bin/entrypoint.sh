#!/bin/bash
set -e

rm -f /app/.internal_test_app/tmp/pids/server.pid
bundle install
sleep 20 # wait for solr to finish its setup work
bundle exec rake db:migrate blacklight:index:seed
bundle exec rails s -p 3000 -b 0.0.0.0
