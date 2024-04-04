#!/bin/sh
cd /app

bundle exec bin/rails db:prepare
bundle exec pumactl -F config/puma.rb start
